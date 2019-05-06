2. consider a schema that represents information about a university
Student (id, name, major, stage, age) -> primary key (id)
Class (name, meetsAt, room, lecturer) -> primary key (name)
Enrolled (student, class, mark) -> primary key (student, class)
Lecturer (id, name, department) -> primary key (id)
Department (id, name) -> primary key (id)
