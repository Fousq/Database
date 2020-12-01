import requests
import AdvancedHTMLParser
import random

STATEMENT = "insert into student(name, surname, birthday, phone, primary_skill_id, created) values ('{0}', '{1}', '{2}', '{3}', {4}, now());\n"

def generatePhone():
    phone = requests.post("https://randommer.io/Phone", data= {'twoLettersCode': 'US'}).json()
    return phone[0]

def generateBirthday():
    year = random.randint(1990, 2000)
    month = random.randint(1, 12)
    day = random.randint(1, 28)
    return str(year) + '-' + ('0' + str(month) if month < 10 else str(month)) + '-' + ('0' + str(day) if day < 10 else str(day))

def generate_student(blockText: str):
    name_surname = blockText[0]
    if name_surname != '':
        (name, surname) = name_surname.split(' ')
        return STATEMENT.format(name, surname, generateBirthday(), generatePhone(), random.randint(1, 3))
    return None

if __name__ == "__main__":
    script_file = open('./insert_data_script.sql', 'a')
    for i in range(10_000):
        html = requests.post("https://www.name-generator.org.uk/quick/").text
        parser = AdvancedHTMLParser.AdvancedHTMLParser()
        parser.parseStr(html)
        elements = parser.getElementsByClassName("name_heading")
        # getBlocksText
        for element in elements.all():
            for blockText in element.getBlocksText():
                student_statement = generate_student(blockText)
                if student_statement is not None:
                    print(student_statement)
                    script_file.write(student_statement)
