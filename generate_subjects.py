import random

TUTOR_STATEMENT = "insert into tutor(name) values ('{0}');\n"
SUBJECT_STATEMENT = "insert into subject(name, tutor_id) values ('{0}', {1});\n"

def generateWord():
    length = random.randint(5, 64)
    word = ''
    while(length > 0):
        word += chr(random.randint(97, 122))
        length -= 1
    return word.capitalize()

if __name__ == "__main__":    
    file = open('./subjects_data.sql', 'w')
    for i in range(1, 1_001):
        file.write(TUTOR_STATEMENT.format(generateWord()))
    file.write('\n')
    for i in range(1, 1_001):
        file.write(SUBJECT_STATEMENT.format(generateWord(), i))