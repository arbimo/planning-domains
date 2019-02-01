#!/usr/bin/python3
import argparse
import math
import os
import random
import string
import sys
from string import Template

template_name = "template.pddl"
ck_template_name = "ck-template.pddl"


class Position:
    def __init__(self, name, dep):
        self.name = name
        self.treatments = set()
        self.dep = dep
    def add_treatment(self, treatment):
        self.treatments.add(treatment)
    def __str__(self):
        return self.name

class Treatment:
    def __init__(self, name):
        self.name = name
    def __str__(self):
        return self.name

class Robot:
    def __init__(self, name, position, reachable_positions, battery_level):
        self.name = name
        self.position = position
        self.reachable_positions = reachable_positions
        self.battery_level = battery_level
    def __str__(self):
        return self.name

class Pallet:
    def __init__(self, name, pos):
        self.name = name
        self.pos = pos

    def __str__(self):
        return self.name



def unload_make_ready_forall(robot, pallet, pos, treatment):
    unload = 'unload {} {} {} {}'.format(robot,pallet,pos,treatment)
    make_ready = 'make_ready {} {} {}'.format(pallet,pos, treatment)
    formula = '(t-forall (?ms - ({}))\n\t (t-exists (?me - ({})) (and {} {})))'.\
             format(unload,make_ready,temporal_constraint_printer('>=','?me','?ms',10),\
                                        temporal_constraint_printer('<=','?me','?ms',20))
    return formula

def load_make_ready_forall(robot, pallet, pos, treatment):
    load = 'load {} {} {} {}'.format(robot,pallet,pos,treatment)
    make_ready = 'make_ready {} {} {}'.format(pallet,pos, treatment)
    formula = '(t-forall (?ms - ({}))\n\t (t-exists (?me - ({})) (and {})))'.\
             format(load,make_ready,temporal_constraint_printer('=','?ms','?me',0.1))
    return formula


def temporal_constraint_printer(sign, a, b, bound):
    return '({} (- {} {}) {})'.format(sign,a,b,bound)

def print_durative_moves_axiom(h,a,b):
    move_start = 'move_start {} {} {}'.format(h.name, a.name, b.name)
    move_end = 'move_end {} {} {}'.format(h.name, a.name, b.name)
    formula = '(t-forall (?ms - ({}))\n\t (t-exists (?me - ({})) (and {})))'.\
             format(move_start,move_end,temporal_constraint_printer('=','?me','?ms',compute_distance(a,b)))
    formula = '(t-forall (?me - ({}))\n\t (t-exists (?ms - ({})) (and {})))'.\
             format(move_end,move_start,temporal_constraint_printer('=','?me','?ms',compute_distance(a,b)))
    return formula

def compute_distance(a,b):
    return abs(a.x-b.x)

def generate_instance(num_robots, num_steps, num_pallets, num_treatments, dir_folder = None, durative_encoding = False, save_on_file = False) :
    if durative_encoding == True:
        template_name = './durative_actions/template.pddl'
    elif durative_encoding == False:
        template_name = 'template.pddl'
    elif durative_encoding == "anml":
        template_name = "majsp.template.anml"

    with open( template_name ) as instream :
        text = instream.read()
        template = string.Template( text )
    template_mapping = dict()
    template_mapping['instance_name'] = 'instance{}_{}_{}'.format(num_robots, num_steps, num_pallets)
    template_mapping['domain_name'] = 'majsp'


    positions_map = dict()
    for i in range(num_steps):
        position = Position('p{}'.format(i), i==num_steps-1)
        positions_map[i] = position
    
    treatment_map = dict()
    for i in range(num_treatments):
        treatment = Treatment('t{}'.format(i))
        treatment_map[i] = treatment
        position_id = i % (num_steps -1)
        positions_map[position_id].add_treatment(treatment)

    robots_map = dict()
    for i in range(num_robots):
        robots_map[i] = Robot('r{}'.format(i),positions_map[num_steps-1],positions_map.values(), float(num_steps*2*num_pallets)/float(1))

    pallets_map = dict()
    for i in range(num_pallets):
        pallets_map[i] = Pallet("b{}".format(str(i)), positions_map[num_steps-1])

    distance_map = dict()
    for i in range(num_steps):
        for j in range(i+1,num_steps):
            distance_map[(positions_map[i].name,positions_map[j].name)] = j-i
            distance_map[(positions_map[j].name,positions_map[i].name)] = j-i

    template_mapping['robots'] = ' '.join(str(x) for x in robots_map.values())
    template_mapping['anml_robots'] = ', '.join(str(x) for x in robots_map.values())
    template_mapping['positions'] = ' '.join(str(x) for x in positions_map.values())
    template_mapping['anml_positions'] = ', '.join(str(x) for x in positions_map.values())
    template_mapping['treatments'] = ' '.join(str(x) for x in treatment_map.values())
    template_mapping['anml_treatments'] = ', '.join(str(x) for x in treatment_map.values())
    template_mapping['pallets'] = ' '.join(str(x) for x in pallets_map.values())
    template_mapping['anml_pallets'] = ', '.join(str(x) for x in pallets_map.values())
    template_mapping['robots_qualitative_position'] = ''.join('\t(robot-at {} {})\n'.format(str(x),x.position) for x in robots_map.values())
    template_mapping['anml_robot_locs'] = ''.join('\t{}.at := {};\n'.format(str(x),x.position) for x in robots_map.values())
    template_mapping['robots_free'] = ''.join('\t(robot-free {})\n'.format(str(x)) for x in robots_map.values())
    template_mapping['anml_robot_free'] = ''.join('\t{}.free := true;\n'.format(str(x)) for x in robots_map.values())
    template_mapping['battery_level'] = ''.join('\t(= (battery-level {}) {})\n'.format(str(x),x.battery_level) for x in robots_map.values())
    template_mapping['position_free'] = ''.join('\t(position-free {})\n'.format(str(x)) for x in positions_map.values())
    template_mapping['anml_position_free'] = ''.join('\t{}.free := true;\n'.format(str(x)) for x in positions_map.values())
    template_mapping['pallets_goal_positions'] = ''.join('\t(treated {} {})\n'.format(y,x.name) for x in treatment_map.values() for y in pallets_map.values())
    template_mapping['anml_processes'] = ',\n  '.join('process({}, {})'.format(y,x.name) for x in treatment_map.values() for y in pallets_map.values())
    template_mapping['pallets_init_positions'] = ''.join('\t(pallet-at {} {})\n'.format(x,x.pos) for x in pallets_map.values())
    template_mapping['anml_pallet_locs'] = ''.join('\t{}.at := {};\n'.format(x,x.pos) for x in pallets_map.values())
    template_mapping['pallets_init_positions'] += '\t(is-depot {})'.format(positions_map[num_steps-1])
    template_mapping['anml_depots'] = '\t{}.is_depot := true;\n'.format(positions_map[num_steps-1])

    template_mapping['positions_can_do'] = ''.join('\t(can-do {} {})\n'.format(x,str(y))  for x in positions_map.values()  if x.dep is False for y in x.treatments)
    template_mapping['anml_can_do'] = ''.join('{}.can_do({}) := true;\n'.format(x,str(y))  for x in positions_map.values()  if x.dep is False for y in x.treatments)
    
    template_mapping['distances'] = ''.join('\t(= (distance {} {}) {})\n'.format(x[0],x[1],distance_map[(x[0],x[1])]) for x in distance_map.keys())
    if save_on_file:
        with open('./temp/instance_{}_{}_{}_{}.pddl'.format(num_robots,num_pallets,num_steps,num_treatments),'w') as file:
            file.write(template.substitute(template_mapping))
        file.close()
    else:
        print(template.substitute(template_mapping))
    

    # with open( ck_template_name ) as instream :
    #     text = instream.read()
    #     template = string.Template( text )
    # template_mapping = dict()
    # template_mapping['instance_name'] = 'instance{}_{}_{}'.format(num_robots, num_steps, num_pallets)
    # template_mapping['domain_name'] = 'majsp'

    # template_mapping['forall_unload_make_ready'] = ''.join('\t {}\n'.format(unload_make_ready_forall(x,y,z,p)) for x in robots_map.values() for y in pallets_map.values() for z in positions_map.values() for p in treatment_map.values())
    # template_mapping['forall_load_make_ready'] = ''.join('\t {}\n'.format(load_make_ready_forall(x,y,z,p)) for x in robots_map.values() for y in pallets_map.values() for z in positions_map.values() for p in treatment_map.values())
    
    # if save_on_file:
    #     with open('./temp/instance_{}_{}_{}_{}_ck.pddl'.format(num_robots,num_pallets,num_steps,num_treatments),'w') as file:
    #         file.write(template.substitute(template_mapping))
    #     file.close()
    # else:
    #     print(template.substitute(template_mapping))
    

def parse_arguments() :
    parser = argparse.ArgumentParser( description = "Generate mais planning instance" )
    parser.add_argument( "--num_robots", required=True, help="Number of robots" )
    parser.add_argument( "--num_positions", required=True, help="Number of positions" )
    parser.add_argument( "--num_pallets", required=True, help="Number of pallets")
    parser.add_argument( "--num_treatments", required=True, help="Number of treatments")
    parser.add_argument( "--durative", dest='durative', help="Whether to durative action", default = False, action = 'store_true')
    parser.add_argument( "--auto", required=False, help="Put a number of instances in the auto_folder iterating till the num foreseen in the input", default = False, action = 'store_true')
    parser.add_argument( "--save_file", required=False, help="Save into a file given as argument", default = False, action = 'store_true')

    args = parser.parse_args()
    #args.random_seed = int(args.random_seed)
    return args

def main() :
    args = parse_arguments()
    generate_instance(int(args.num_robots), int(args.num_positions), int(args.num_pallets), int(args.num_treatments), durative_encoding = "anml")
    # auto_folder = args.auto
    # print('Instance constructor about to be called')
    # if auto_folder == False:
    #     print('Generate single instance')
    #     generate_instance(int(args.num_robots), int(args.num_positions), int(args.num_pallets), int(args.num_treatments), save_on_file = args.save_file)  
    # else:
    #     if not os.path.exists('temp'):
    #         os.makedirs('temp')
    #     print("Instances are going to be put in temp for the time being")
    #     for j in range(1,int(args.num_robots)+1):
    #         for i in range(2,int(args.num_positions)+1):
    #             for k in range(1,int(args.num_pallets)+1):
    #                 for t in range(1,int(args.num_treatments)+1):
    #                     print('Generate instance for {} {} {} {}'.format(j,i,k,t))
    #                     generate_instance(j, i, k, t, save_on_file=True, durative_encoding = args.durative == True)  

if __name__ == '__main__' :
    main()
