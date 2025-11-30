.MODEL SMALL
;=========================
.STACK 100H
.DATA
;=========================
HEADING DB '========== EMPLOYEE HOURS SYSTEM ==========','$'
FirstChoice DB '1- Enter working hours','$'
SecondChoice DB '2- Calculate salaries','$'
ThirdChoice DB '3- Show report','$'
ExitChoice DB '4- Exit','$'
NewLine DB 0Dh,0Ah,'$'
Choose DB 'Choose: ','$'
Choice DB ?
NumberOfEmployees DW ?
NumberOFEmployeesMessage DB 'Enter Number Of Employees: ','$'
EmployeeHoursMessage DB 'Enter hours for Employee ','$'
HOURS DB 10 DUP(?)
HourRate DW 50
Salaries DW 10 DUP(?)
StatusNormal DB 'Normal','$'
StatusOver DB 'Overtime','$'
StatusLow DB 'Low Hours','$'
MaxHours DB ?
MinHours DB ?
ReportString DB 0Dh,0Ah,'----------- REPORT -----------',0Dh,0Ah,'$'
TableFirstRow DB 'Emp     Hours     Salary       Status',0Dh,0Ah,'$'
LineString DB 0Dh,0Ah,'--------------------------------',0Dh,0Ah,'$'
SalaryCalculatedMsg DB 0Dh,0Ah,'Salaries Calculated.',0Dh,0Ah,'$'
MaxEmployeeNumber DB ?
MinEmployeeNumber DB ?
MaxMsg          DB 'Max Hours: ','$'
MinMsg          DB 'Min Hours: ','$'
EmpParen1       DB ' (Employee ','$'
EmpParen2       DB ')',0Dh,0Ah,'$'
TabStr DB "         $"    
;=========================
.CODE
;=========================
   MAIN PROC FAR
       .STARTUP
       ;=========================
       ; displaying menu
       ;=========================
       Menu:
          LEA DX,NewLine
          CALL PRINT
          
          LEA DX,HEADING
          CALL PRINT
          
          LEA DX,NewLine
          CALL PRINT 
           
          LEA DX,NewLine
          CALL PRINT
          
          LEA DX,FirstChoice
          CALL PRINT
          
           LEA DX,NewLine
          CALL PRINT
          
          LEA DX,SecondChoice
          CALL PRINT
          
          LEA DX,NewLine
          CALL PRINT
          
          LEA DX,ThirdChoice
          CALL PRINT
          
          LEA DX,NewLine
          CALL PRINT
          
          LEA DX,ExitChoice
          CALL PRINT
          
          LEA DX,NewLine
          CALL PRINT
          
          LEA DX,Choose
          CALL PRINT
          
          ; read user choice 
          CALL READ 
          ;Compare by choice number and jump to label
          CMP AL,1
          JE EnterWorkingHours
          CMP AL,2
          JE CalculateSalaries
          CMP AL,3
          JE ShowReport
          ;any char else will exit the program
          JMP Exit
          
       ;=========================
       ;First Choice
       ;=========================
       EnterWorkingHours:
          LEA DX,NewLine
          CALL PRINT
          
          LEA DX,NumberOFEmployeesMessage ; Mesage to enter number of employees
          CALL PRINT 
          
          CALL READ ;read number of employees in AL
          CBW   ; AL -> AX    ->Convert Byte to Word
          MOV NumberOfEmployees,AX
          MOV CX,NumberOfEmployees
          MOV SI,0
          
          HoursLabel:
              LEA DX,NewLine
              CALL PRINT
              
              LEA DX,NewLine
              CALL PRINT
              
              LEA DX,EmployeeHoursMessage ; Message to enter hours for employee
              CALL PRINT
              
              MOV AX,SI      ;print index of the current employee(One-Indexed)   
              ADD AL,1
              ADD AL,30H
              MOV DL,AL
              MOV AH,02H
              INT 21H
              
              MOV DL, ':'   ;print colon
              INT 21H 
               
              CALL READ     ; read number of hours for the current employee in LA
              
              MOV HOURS[SI],AL   ; set employee hours in array
              INC SI
          LOOP HoursLabel
          JMP Menu
          ;=========================
          ; Second Choice
          ;=========================
       CalculateSalaries:
          MOV SI,0
          MOV CX,NumberOfEmployees   ; loop to calculate salary for employees
          
         CalcEmployeeSalary:
          MOV AL,HOURS[SI]
          CBW  ;AL ->AX   -> Byte extend to Word
          MOV BX,HourRate
          MUL BX   ; multiply AX*BX (HourRate * num of Hours)   ->result in AX
          
          MOV DI, SI
          SHL DI, 1         ; DI = SI*2  -> next 2 bytes (WORD)
          MOV [Salaries + DI], AX   ; set next 2 bytes(WORD) of salaries array to result of multiplication
          INC SI
          LOOP CalcEmployeeSalary  
          LEA DX,NewLine
          CALL PRINT
          LEA DX, SalaryCalculatedMsg
          CALL PRINT
         
          JMP Menu
          ;=========================
         ; Third Choice
         ;=========================
       ShowReport:
         ; print report with all employees data
         LEA DX,ReportString
         CALL PRINT
         
         LEA DX,TableFirstRow
         CALL PRINT
         
         MOV SI,0
         MOV CX,NumberOfEmployees
         
         EmployeeData:
              MOV AX,SI  ; print Employee Number       
              ADD AL,1
              ADD AL,30H
              MOV DL,AL  ; Print char in DL
              MOV AH,02H
              INT 21H
              
              LEA DX,TabStr  ; space
              CALL PRINT
              
              ;print employee hours
              MOV AL,HOURS[SI]  ; get hours
              ADD AL,30H        ; convert to ASCII 
              MOV DL,AL
              MOV AH,02H
              INT 21H           ; print character

              
              LEA DX,TabStr  ; space
              CALL PRINT
              
              ;print employee salary according to working hours
              MOV DI, SI
              SHL DI, 1            ; DI = SI*2
              MOV AX, [Salaries + DI]   
              CALL PrintNumber          
              
              LEA DX,TabStr  ; space
              CALL PRINT
              
              ;print employee status according to working hours
              MOV AL,HOURS[SI]
              CMP AL,8   ; >8  overtime
              JGE OverTime
              
              CMP AL,5
              JLE LowTime   ; <5 lowtime
              
              ; else NormalStatus
              LEA DX, StatusNormal
              CALL PRINT
              
              JMP Skip  ; to continue printing the next employee data without entering the lables
              
              OverTime:
                 LEA DX, StatusOver
                 CALL PRINT
                 JMP Skip
              LowTime:
                 LEA DX, StatusLow
                 CALL PRINT
              Skip:
                 INC SI
                 LEA DX,NewLine
                 CALL PRINT
                 LOOP EmployeeData
             LEA DX ,LineString
             CALL PRINT
             LEA DX,MaxMsg ; print (Max Hours)
             CALL PRINT
             CALL FindMax  ; calculate max hours and num of its employee 
             
             
             MOV AL,MaxHours  ; print maxhours
             ADD AL,30H        ; convert to ASCII 
             MOV DL,AL
             MOV AH,02H
             INT 21H  
              
             LEA DX,EmpParen1   
             CALL PRINT
             
             
              MOV AL,MaxEmployeeNumber  ; print Emp with maxhours
              ADD AL,30H        ; convert to ASCII 
              MOV DL,AL
              MOV AH,02H
              INT 21H  
             
             
             LEA DX,EmpParen2
             CALL PRINT
             
             LEA DX,NewLine
             CALL PRINT 
             
             
             
             LEA DX,MinMsg   ; print (MinHours)
             CALL PRINT
             
             CALL FindMin   ; calculate min hours with its employee number
             MOV AL,MinHours  ; print minhours
              ADD AL,30H        ; convert to ASCII 
              MOV DL,AL
              MOV AH,02H
              INT 21H
              
             
             
             LEA DX,EmpParen1
             CALL PRINT
             
             MOV AL,MinEmployeeNumber  ; print Emp with minhours
              ADD AL,30H        ; convert to ASCII 
              MOV DL,AL
              MOV AH,02H
              INT 21H
             
             LEA DX,EmpParen2
             CALL PRINT
             
             LEA DX,NewLine
             CALL PRINT
             
             
             JMP Menu
           ;=========================  
           ; Fourth Choice
           ;=========================
       Exit:
           .EXIT
       
  MAIN ENDP

;-------------------------------
; Procedure to print string in DX  
  PRINT PROC NEAR
        Mov AH,09H
        INT 21H
        RET
  PRINT ENDP

;-------------------------------
;Procedure to read char in AL  
  READ PROC NEAR
       MOV AH,01H
       INT 21H
       SUB AL,30H
       RET
  READ ENDP

;-------------------------------
; Procedure to find maximum work hours
  FindMax PROC NEAR
    MOV SI,0
    MOV CX,NumberOfEmployees

    
    MOV AL, HOURS[SI]
    MOV MaxHours, AL  ; consider the first element is the max then compare

    
    MOV MaxEmployeeNumber, 1   ; consider the first employee have the max hours

    CalculateMax:
    MOV AL, HOURS[SI]
    CMP AL, MaxHours
    JLE NextEmp  ;if not greater continue to the next employee in loop

    ; else -> update maxhours value and employee number
    MOV MaxHours, AL
    MOV AX, SI
    INC AX   ;-> One-Indexed
    MOV MaxEmployeeNumber, AL  

    NextEmp:
    INC SI
    LOOP CalculateMax

    RET
  FindMax ENDP

;-------------------------------
; Procedure to find maximum work hours  
 FindMin PROC NEAR
    MOV SI,0
    MOV CX,NumberOfEmployees

    
    MOV AL, HOURS[SI]
    MOV MinHours, AL  ; consider the first element is the min then compare

    
    MOV MinEmployeeNumber, 1   ; consider the first employee have the min hours

    CalculateMin:
    MOV AL, HOURS[SI]
    CMP AL, MinHours
    JGE NextEmpMin       ;if greater or equal continue to the next employee in loop
    
    ; else -> update minhours value and employee number
    MOV MinHours, AL  
    MOV AX, SI
    INC AX
    MOV MinEmployeeNumber, AL

    NextEmpMin:
    INC SI
    LOOP CalculateMin

    RET
  FindMin ENDP


;-------------------------------
; Procedure to print number with multiple digits
 PrintNumber PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    CMP AX, 0
    JNE PN_Convert
    ; print '0'
    MOV DL, '0'
    MOV AH,02h
    INT 21h
    JMP PN_Done

 PN_Convert:
    XOR CX, CX          ; digit count in number(salary of employee)
 PN_Loop:
    XOR DX, DX          ; DX=0
    MOV BX, 10
    DIV BX              ; AX = AX / 10, DX = remainder  -> TO get the first digit in salary (in DX)
    PUSH DX             ; push digit in stack
    INC CX              ; increament num of digits
    CMP AX, 0           ; salary = 0 ? 
    JNE PN_Loop         ; if not -> continue to get the rest of the digits in salary

    PN_Print:           ; else 
    POP DX              ; pop didgit in stack (in DX)
    ADD DL, '0'         ; convert to ASCII
    MOV AH,02h          ; print digit
    INT 21h
    LOOP PN_Print

 PN_Done: 
    POP DX
    POP CX
    POP BX
    POP AX
    RET
 PrintNumber ENDP
       
 
END MAIN