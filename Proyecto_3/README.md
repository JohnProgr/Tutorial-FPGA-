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
    C0[carry[0] = 1] --> C1[divider_cell bit 0]
    C1 -->|carry[1]| C2[divider_cell bit 1]
    C2 -->|carry[2]| C3[divider_cell bit 2]
    C3 -->|carry[3]| C4[divider_cell bit 3]
    C4 -->|carry[4]| CO[cout_o]

    R0[r_i[0]] --> C1
    B0[b_i[0]] --> C1
    A0[accept_i] --> C1
    C1 --> D0[diff_o[0]]
    C1 --> N0[r_next_o[0]]

    R1[r_i[1]] --> C2
    B1[b_i[1]] --> C2
    A1[accept_i] --> C2
    C2 --> D1[diff_o[1]]
    C2 --> N1[r_next_o[1]]

    R2[r_i[2]] --> C3
    B2[b_i[2]] --> C3
    A2[accept_i] --> C3
    C3 --> D2[diff_o[2]]
    C3 --> N2[r_next_o[2]]

    R3[r_i[3]] --> C4
    B3[b_i[3]] --> C4
    A3[accept_i] --> C4
    C4 --> D3[diff_o[3]]
    C4 --> N3[r_next_o[3]]
```
Fila de 4 bits construida a partir de varias celdas divider_cell conectadas en cascada, donde el acarreo se propaga entre celdas y se obtiene una resta completa del residuo parcial contra el divisor.

## Apendices:
### Apendice 1:
texto, imágen, etc
