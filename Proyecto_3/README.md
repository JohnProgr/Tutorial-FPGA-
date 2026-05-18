# Nombre del proyecto

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Desarrollo

### 3.0 Descripción general del sistema

### 3.1 Módulo 1
#### 1. Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```
#### 2. Parámetros
- Lista de parámetros

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas

### Otros modulos
- agregar informacion siguiendo el ejemplo anterior.


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto

## Diagramas para informe

Diagrama general
```mermaid
flowchart TD
    A[Teclado hexadecimal] --> B[Subsistema de lectura]
    B --> C[Conversión BCD a binario]
    C --> D[Subsistema de división entera]
    D --> E[Conversión binario a BCD]
    E --> F[Selector cociente / residuo]
    F --> G[Display 7 segmentos]
```

Diagrama divider_cell
```mermaid
flowchart LR
    A[r_i] --> S[Resta por complemento a 2]
    B[b_i] --> S
    C[cin_i] --> S

    S --> D[diff_o]
    S --> E[cout_o]

    A --> M[MUX]
    D --> M
    F[accept_i] --> M
    M --> G[r_next_o]
```
Celda básica de 1 bit que realiza una resta por complemento a dos y selecciona entre el resultado calculado o el residuo original según accept_i.

Diaframa divider_row
```mermaid
flowchart LR
    START["carry inicial = 1"] --> C0["Celda bit 0"]
    C0 -->|"carry"| C1["Celda bit 1"]
    C1 -->|"carry"| C2["Celda bit 2"]
    C2 -->|"carry"| C3["Celda bit 3"]
    C3 --> COUT["cout_o"]

    RI["r_i de 4 bits"] --> C0
    RI --> C1
    RI --> C2
    RI --> C3

    BI["b_i de 4 bits"] --> C0
    BI --> C1
    BI --> C2
    BI --> C3

    ACC["accept_i común"] --> C0
    ACC --> C1
    ACC --> C2
    ACC --> C3

    C0 --> D0["diff_o bit 0 / r_next_o bit 0"]
    C1 --> D1["diff_o bit 1 / r_next_o bit 1"]
    C2 --> D2["diff_o bit 2 / r_next_o bit 2"]
    C3 --> D3["diff_o bit 3 / r_next_o bit 3"]
```
Fila de 4 bits construida a partir de varias celdas divider_cell conectadas en cascada, donde el acarreo se propaga entre celdas y se obtiene una resta completa del residuo parcial contra el divisor.

Diagrama divider_stage
```mermaid
flowchart LR
    RI["r_i de 4 bits"] --> ROW["divider_row"]
    BI["b_i de 4 bits"] --> ROW
    ACC["accept_i fijo en 1"] --> ROW

    ROW --> DIFF["diff_o de 4 bits"]
    ROW --> COUT["cout_o"]

    RI --> MUX["MUX selector de residuo"]
    DIFF --> MUX
    COUT --> MUX

    MUX --> RNEXT["r_next_o de 4 bits"]

    COUT --> QBIT["q_bit_o"]
```
divider_stage representa una etapa de decisión del divisor. Internamente utiliza divider_row para intentar restar el divisor al residuo parcial, forzando accept_i en 1 para obtener el resultado de la resta. Luego, el acarreo final cout_o se utiliza como señal de decisión: si cout_o es 1, la resta fue válida y se acepta diff_o como nuevo residuo; si cout_o es 0, la resta no fue válida y se conserva el residuo anterior r_i. Esta misma señal se entrega como q_bit_o, correspondiente al bit del cociente generado por la etapa.

Diagrama divider_comb 
```mermaid
flowchart TD
    A["dividend_i de 6 bits"] --> S5["Etapa bit 5"]
    B["divisor_i de 4 bits"] --> S5
    S5 --> Q5["quotient bit 5"]
    S5 --> S4["Etapa bit 4"]

    B --> S4
    S4 --> Q4["quotient bit 4"]
    S4 --> S3["Etapa bit 3"]

    B --> S3
    S3 --> Q3["quotient bit 3"]
    S3 --> S2["Etapa bit 2"]

    B --> S2
    S2 --> Q2["quotient bit 2"]
    S2 --> S1["Etapa bit 1"]

    B --> S1
    S1 --> Q1["quotient bit 1"]
    S1 --> S0["Etapa bit 0"]

    B --> S0
    S0 --> Q0["quotient bit 0"]
    S0 --> R["remainder_o"]
```

## Apendices:
### Apendice 1:
texto, imágen, etc
