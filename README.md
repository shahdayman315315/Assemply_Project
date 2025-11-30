# HR System (Employee Hours System)

> **Assembly Language Project** – Small Model, DOS Interrupts (INT 21H)

---

## Table of Contents

- [Project Overview](#project-overview)  
- [Features](#features)  
- [Requirements](#requirements)  
- [How to Run](#how-to-run)  
- [Code Structure](#code-structure)  
- [Menu Options](#menu-options)  
- [Demo](#demo)  
- [Author](#author)  

---

## Project Overview

The **Employee Hours System** is a simple console-based program written in **x86 Assembly** (MASM/TASM).  
It allows you to manage employees’ working hours, calculate their salaries, and generate a report with employee statistics.

The program uses **DOS interrupts (INT 21H)** for input/output operations and works on the **.MODEL SMALL** memory model.

---

## Features

- Input the number of employees.  
- Enter working hours for each employee.  
- Calculate salaries automatically based on a fixed hourly rate.  
- Display a detailed report:
  - Employee number  
  - Hours worked  
  - Salary  
  - Status (Normal, Overtime, or Low Hours)  
- Highlight the employee with **maximum** and **minimum** working hours.  
- Simple interactive menu with options to navigate.  

---

## Requirements

- MASM / TASM assembler  
- DOSBox or any DOS-compatible environment  
- Basic knowledge of running `.EXE` files in DOS  

---

## How to Run

1. Open **MASM or TASM**.  
2. Assemble the program:  

```bash
ml EmployeeHours.asm
```

3. Link the object file:  

```bash
link EmployeeHours.obj
```

4. Run the program in DOSBox or your preferred DOS environment:  

```bash
EmployeeHours.exe
```

5. Follow the on-screen menu options.

---

## Code Structure

The program is divided into several sections:

### 1. Data Segment (`.DATA`)

- **Strings:** Menu headings, prompts, and messages.  
- **Arrays:** `HOURS` for storing employee hours, `Salaries` for storing calculated salaries.  
- **Variables:** `NumberOfEmployees`, `MaxHours`, `MinHours`, and employee numbers for min/max hours.

### 2. Code Segment (`.CODE`)

- **MAIN PROC**: The main program loop.  
- **Menu Section**: Prints the interactive menu and reads user input.  
- **Choice Handlers**:
  - `EnterWorkingHours`: Input hours for each employee.  
  - `CalculateSalaries`: Multiply hours by a fixed rate (50 per hour).  
  - `ShowReport`: Display employee details and statistics.  
  - `Exit`: Terminate the program.

### 3. Procedures

- **PRINT**: Prints a string stored in `DX`.  
- **READ**: Reads a single character input and converts it to a numeric value.  
- **FindMax**: Finds the maximum hours and corresponding employee.  
- **FindMin**: Finds the minimum hours and corresponding employee.  
- **PrintNumber**: Prints multi-digit numbers (used for salary display).  

---

## Menu Options

| Option | Description |
|--------|-------------|
| 1      | Enter working hours for employees |
| 2      | Calculate salaries based on hours |
| 3      | Show report of employees with their hours, salary, and status |
| 4      | Exit the program |

**Status Rules:**

- **Overtime:** Hours ≥ 8  
- **Normal:** Hours between 5 and 7  
- **Low Hours:** Hours ≤ 5  

---

## Demo

```
[Watch Demo Video](https://drive.google.com/file/d/1zr-FKDlkVV-9e-LaqFN-wxyuo_PqLj3o/view?usp=drive_link)
```

Example menu interaction:

```
========== EMPLOYEE HOURS SYSTEM ==========
1- Enter working hours
2- Calculate salaries
3- Show report
4- Exit
Choose: _
```

---

## Author

- **Name:** Shahd Ayman Lotfy
- **Name:** Alia Mahmoud Harb
- **Course:**  Assembly 
- **University:** Mansoura University  

---

> This project is implemented entirely in **x86 Assembly** and demonstrates array handling, loops, and basic DOS input/output.
