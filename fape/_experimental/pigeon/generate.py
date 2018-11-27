from string import Template
import argparse

parser = argparse.ArgumentParser(description='Generate a pigeon problem.')
# parser.add_argument('integers', metavar='N', type=int, nargs='+',
#                    help='an integer for the accumulator')
parser.add_argument("-p", type=int,                   help='number of pigeons')


args = parser.parse_args()

num_pigeons = args.p

#open the file
filein = open( 'pigeon.template.anml' )
#read it
src = Template( filein.read() )
#document data
pigeons = ['p'+str(i) for i in range(0, num_pigeons)]
holes = ['h'+str(i) for i in range(0, num_pigeons)]

subtitle = "And this is the subtitle"
list = ['first', 'second', 'third']
d = {
    'pigeons': ', '.join(pigeons),
    'holes': ', '.join(holes),
    'init': '\n\t'.join(['occupied('+h+') := false;' for h in holes]),
    'goals':'\n\t'.join(['in_hole('+p+') == true;' for p in pigeons])
    }
#do the substitution
result = src.substitute(d)
print result
