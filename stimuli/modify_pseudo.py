
with open('pseudowords.csv', 'r') as f:
    lines = f.readlines()
lines = [l.split(',')[1].strip() for l in lines]

with open('pseudowords_.csv', 'w') as f:
    for l in lines:
        f.write(f'{l}\n')

