#!/usr/bin/python3
import argparse
import math
import os
import random
import string
import sys
from string import Template

mode = "anml"
anml_template_name = "hsp.template.pb.anml"
htn_anml_template_name = "hsp-htn.template.pb.anml"
template_name = "template.pddl"
ck_template_name = "ck-template.pddl"


class Position:
    def __init__(self, name, x):
        self.name = name
        self.x = x
    def __str__(self):
        return self.name

class Hoist:
    def __init__(self, name, position, reachable_positions):
        self.name = name
        self.position = position
        self.reachable_positions = reachable_positions
    def __str__(self):
        return self.name

class Recipe:
    def __init__(self, name, actions):
        self.name = name
        self.actions = actions
    def __str__(self):
        return self.name+' '+' '.join(str(x) for x in self.actions)

class Bar:
    def __init__(self, name, recipe):
        self.name = name
        self.recipe = recipe
    def __str__(self):
        return self.name



def formula_printer(bar, j = 0, variables = list()):
    if (len(bar.recipe.actions) == j ):
        input = ''
        for i in range(0,len(variables)-1,2):
            a = variables[i]
            b = variables[i+1]
            if i == 0 or i == len(variables)-2:
                input += '({} (- {} {}) {})'.format('=', b, a, 60)
            else:
                input += '({} (- {} {}) {})'.format('>=', b, a, 10)
                input += '({} (- {} {}) {})'.format('<=', b, a, 30)
        return '(and {})'.format(input)
    else:
        quantifier = 't-exists'
        action_var = '?{}'.format(bar.recipe.actions[j].replace(' ',''))
        action_name = bar.recipe.actions[j]
        variables.append(action_var)
        return '({} ({} - ({})) \n\t\t{})'.format(quantifier,action_var,action_name,formula_printer(bar, j+1, variables))

def temporal_constraint_printer(sign, a, b, bound):
    return '({} (- {} {}) {})'.format(sign,a,b,bound)

def print_durative_moves_axiom(h,a,b):
    move_start = 'move_start {} {} {}'.format(h.name, a.name, b.name)
    move_end = 'move_end {} {} {}'.format(h.name, a.name, b.name)
    formula = '(t-forall (?ms - ({}))\n\t (t-exists (?me - ({})) (and {})))\n'.\
             format(move_start,move_end,temporal_constraint_printer('=','?me','?ms',compute_distance(a,b)))
    formula += '\t(t-forall (?me - ({}))\n\t (t-exists (?ms - ({})) (and {})))'.\
             format(move_end,move_start,temporal_constraint_printer('=','?me','?ms',compute_distance(a,b)))
    return formula

def compute_distance(a,b):
    return abs(a.x-b.x)

def generate_instance(num_hoists, num_steps, num_bars, mode, dir_folder = None) :
    """Mode should be a string in tpp, durative, anml"""

    if mode == "durative":
        template_name = './durative_actions/template.pddl'
    elif mode == "tpp":
        template_name = 'template.pddl'
    elif mode == "anml":
        template_name = anml_template_name
    elif mode == "anml_htn":
        template_name = htn_anml_template_name
    else:
        sys.error("Wrong mode: "+mode)


    with open( template_name ) as instream :
        text = instream.read()
        template = string.Template( text )
    template_mapping = dict()
    template_mapping['instance_name'] = 'instance{}_{}_{}'.format(num_hoists, num_steps, num_bars)
    template_mapping['domain_name'] = 'mais'

    positions_map = dict()
    x = 0
    for i in range(num_steps):
        position = Position('p{}'.format(i),x)
        positions_map[i] = position
        x = x + 10

    hoists_map = dict()

    loading_factor = int((num_steps-1)/num_hoists)
    k = 0
    j = 0
    
    hoists_positions_assignment = dict()
    for i in range(num_hoists):
        hoists_map[i] = Hoist('h{}'.format(i),positions_map[j],positions_map.values())
        j = j + 1
        position_allocated = {positions_map[p] for p in range(k,k+loading_factor+1)}
        k = k + loading_factor
        hoists_positions_assignment[hoists_map[i]] = position_allocated

    positions_to_hoist_assignment = dict()
    for key, value in hoists_positions_assignment.items():
        for ele in value:
            positions_to_hoist_assignment[ele] = key

    bars_map = dict()
    for i in range(num_bars):
        bar_name = 'b{}'.format(i)
        #TODO    
        actions = ['prepare_bar {} {}'.format(bar_name, positions_map[0])]
        actions += ['load {} {} {}'.format(positions_to_hoist_assignment[positions_map[j]].name,bar_name,positions_map[0].name)]
        for j in range(1,num_steps-1):
            actions += ['unload {} {} {}'.format(positions_to_hoist_assignment[positions_map[j]].name,bar_name,positions_map[j].name)]
            actions += ['load {} {} {}'.format(positions_to_hoist_assignment[positions_map[j]].name,bar_name,positions_map[j].name)]
        
        actions += ['unload {} {} {}'.format(positions_to_hoist_assignment[positions_map[num_steps-1]].name,bar_name,positions_map[num_steps-1].name)]
        actions += ['finish_bar {} {}'.format(bar_name,positions_map[num_steps-1].name)]
        recipe = Recipe('r{}'.format(bar_name),actions)
        bars_map[i] = Bar(bar_name, recipe)


    template_mapping['hoists'] = ' '.join(str(x) for x in hoists_map.values())
    template_mapping['anml_hoists'] = ', '.join(str(x) for x in hoists_map.values())
    template_mapping['positions'] = ' '.join(str(x) for x in positions_map.values())
    template_mapping['anml_positions'] = ', '.join(str(x) for x in positions_map.values())
    template_mapping['bars'] = ' '.join(str(x) for x in bars_map.values())
    template_mapping['anml_bars'] = ', '.join(str(x) for x in bars_map.values())
    template_mapping['anml_bars_init_loc'] = ''.join('\t{}.at := void;\n'.format(x) for x in bars_map.values())

    template_mapping['hoists_qualitative_position'] = ''.join('\t(hoist-at {} {})\n'.format(str(x),x.position) for x in hoists_map.values())
    template_mapping['hoists_metric_position'] = ''.join('\t(= (hoist-dest-x {}) {})(= (hoist-x {}) {})\n'.format(str(x),x.position.x,str(x),x.position.x) for x in hoists_map.values())
    template_mapping['anml_hoists_qualitative_position'] = ''.join('\t{}.at := {};\n'.format(str(x),x.position) for x in hoists_map.values())

    template_mapping['hoists_reachable_positions'] = ''.join('\t(can-go {} {})\n'.format(str(x),y)  for x in hoists_map.values() for y in x.reachable_positions)
    template_mapping['anml_hoists_reachable_positions'] = ''.join('{}.can_go({}) := true;\n'.format(str(x),y)  for x in hoists_map.values() for y in x.reachable_positions)
    
    template_mapping['hoists_free'] = ''.join('\t(hoist-free {})\n'.format(str(x)) for x in hoists_map.values())
    template_mapping['anml_hoists_free'] = ''.join('\t{}.free := true;\n'.format(str(x)) for x in hoists_map.values())

    template_mapping['hoists_time'] = ''.join('\t(= (hoist-time {} {} {}) {})\n'.format(str(x),y,z,compute_distance(y,z))\
                                        for x in hoists_map.values() for y in x.reachable_positions for z in x.reachable_positions)
    template_mapping['positions_x'] = ''.join('\t(= (x {}) {})\n'.format(x,x.x) for x in positions_map.values())
    template_mapping['positions_free'] = ''.join('\t(position-free {})\n'.format(x) for x in positions_map.values())
    template_mapping['anml_positions_free'] = ''.join('\t{}.free := true;\n'.format(x) for x in positions_map.values())

    template_mapping['bar_step_info'] = ''.join('\t(= (step {}) -1)\n'.format(x) for x in bars_map.values())
    template_mapping['bar_last_step_info'] = ''.join('\t(= (last-step {}) {})\n'.format(x,len(positions_map)-1) for x in bars_map.values())
    template_mapping['bars_last_step_constraint'] = ''.join('\t(= (step {}) (+ (last-step {}) 1))\n'.format(x,x) for x in bars_map.values())
    template_mapping['bars_position_processed'] = ''.join('\t(processed {} {})\n'.format(y,x) for x in positions_map.values() for y in bars_map.values())
    template_mapping['loading_unloading_plant_positions'] = '\t(plant_loading_position p0)\n'+'\t(plant_unloading_position {})'.format(positions_map[num_steps-1])
    template_mapping['anml_loading_unloading_plant_positions'] = '\tplant_loading_position := p0;\n'+'\tplant_unloading_position := {};'.format(positions_map[num_steps-1])

    template_mapping['anml_bars_position_processed_goals'] = ''.join('\t{}.processed({}) == true;\n'.format(y,x) for x in list(positions_map.values())[0:-1] for y in bars_map.values())
    template_mapping['anml_bars_position_processed_tasks'] = ''.join('\tstep({}, {});\n'.format(y,x) for x in list(positions_map.values())[1:-1] for y in bars_map.values())
    template_mapping['anml_bars_processed'] = ''.join('\tprocess({});\n'.format(x) for x in bars_map.values())
    template_mapping['anml_substeps'] = ',\n\t\t\t'.join('step(b, {})'.format(x) for x in list(positions_map.values())[1:-1])
    
    if (dir_folder is None):
        print(template.substitute(template_mapping))
    else:
        with open('./{}/instance{}_{}_{}.pddl'.format(dir_folder,num_hoists,num_steps,num_bars),'w') as f:
            f.write(template.substitute(template_mapping))
        f.close()

    if mode == "tpp":
        with open( ck_template_name ) as instream :
            text = instream.read()
            ck_template = string.Template( text )
        
        ck_template_mapping = dict()
        ck_template_mapping['recipe_info'] = '\n'.join('\t{}'.format(formula_printer(x,variables=list())) for x in bars_map.values())
        ck_template_mapping['moves_duration'] =  '\t\n'.join('\t'+print_durative_moves_axiom(x,y,z) \
                                            for x in hoists_map.values() for y in x.reachable_positions for z in x.reachable_positions if y.x != z.x)
    
        if (dir_folder is None):
            print(ck_template.substitute(ck_template_mapping))
        else:
            with open('./{}/instance{}_{}_{}_ck.pddl'.format(dir_folder,num_hoists,num_steps,num_bars),'w') as f:
                f.write(ck_template.substitute(ck_template_mapping))
            f.close()

def parse_arguments() :
    parser = argparse.ArgumentParser( description = "Generate mais planning instance" )
    parser.add_argument( "--num_hoists", required=True, help="Number of hoists" )
    parser.add_argument( "--num_positions", required=True, help="Number of positions" )
    parser.add_argument( "--num_bars", required=True, help="Number of bars")
    parser.add_argument( "--mode", required=True, help="Target language: tpp, anml or durative")
    parser.add_argument( "--auto_folder", required=False, help="Put a number of instances in the auto_folder iterating till the num foreseen in the input")

    args = parser.parse_args()
    #args.random_seed = int(args.random_seed)
    return args

def main() :
    args = parse_arguments()
    auto_folder = args.auto_folder

    if auto_folder == None:
        generate_instance(int(args.num_hoists), int(args.num_positions), int(args.num_bars), args.mode)  
    else:
        if not os.path.exists(auto_folder):
            os.makedirs(auto_folder)
        for i in range(1,int(args.num_positions)+1):
            for j in range(1,min(int(args.num_hoists),i-1)+1):
                for k in range(1,int(args.num_bars)+1):
                    generate_instance(j, i, k, auto_folder, args.mode, args.durative == True)  
    

if __name__ == '__main__' :
    main()
