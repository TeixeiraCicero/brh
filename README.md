# {c:blue}BRH {/c}

 

## O ID do projeto BRH é o ID 4  
## O projeto atualmente contém  {c:green}3{/c} colaboradores 
## O projeto se iniciou na data 01/05/2022 
## Ainda está em andamento 
## Sem data prevista para término 

### No projeto temos,  {c:yellow}Atribuição, Colaborador, Departamento, Dependente, Endereço, Papel, Projeto, Telefone{/c}
### Alguns dos relatorios importantes são
```
SELECT COLAB.NOME AS COLAB_NOME, DEP.NOME AS NOME_DEP, DEP.DATA_NASCIMENTO
FROM BRH.COLABORADOR COLAB
JOIN BRH.DEPENDENTE DEP
ON COLAB.MATRICULA = DEP.COLABORADOR
WHERE TO_CHAR(DEP.DATA_NASCIMENTO, 'MM')IN(04, 05, 06) or UPPER(DEP.NOME) LIKE '%H%'
ORDER BY COLAB.NOME, DEP.NOME

~~~~~~~~~~

SELECT COLAB.NOME, COLAB.SALARIO
FROM BRH.COLABORADOR COLAB
WHERE COLAB.SALARIO = 
(SELECT MAX (BRH.COLABORADOR.SALARIO)FROM BRH.COLABORADOR) 
ORDER BY COLAB.SALARIO DESC

~~~~~~~~~~

SELECT COLAB.MATRICULA, COLAB.NOME, COLAB.SALARIO,
(CASE WHEN COLAB.SALARIO <= 3000.00 THEN 'Júnior'
WHEN COLAB.SALARIO >=3000.01 
AND COLAB.SALARIO <= 6000.00  THEN 'Pleno'
WHEN COLAB.SALARIO >=6000.01 
AND COLAB.SALARIO <= 20000.00 THEN 'Sênior'
ELSE 'Corpo diretor'
END)AS SENIORIDADE
FROM BRH.COLABORADOR COLAB
ORDER BY SENIORIDADE, COLAB.NOME

~~~~~~~~~~

SELECT DEP.NOME AS DEPARTAMENTO, PROJ.NOME AS PROJETO, COUNT (*)AS NUMERO_COLAB
FROM BRH.DEPARTAMENTO DEP
INNER JOIN BRH.COLABORADOR COLAB 
ON DEP.SIGLA = COLAB.DEPARTAMENTO
INNER JOIN BRH.ATRIBUICAO ATT
ON COLAB.MATRICULA = ATT.COLABORADOR
INNER JOIN BRH.PROJETO PROJ
ON ATT.PROJETO = PROJ.ID
GROUP BY DEP.NOME,PROJ.NOME
ORDER BY DEP.NOME, PROJ.NOME
  
~~~~~~~~~~

SELECT COLAB.NOME,COUNT (*)AS DEPENDENTES
FROM BRH.DEPENDENTE DEP
INNER JOIN BRH.COLABORADOR COLAB
ON DEP.COLABORADOR = COLAB.MATRICULA
GROUP BY COLAB.NOME 
HAVING COUNT (*) >= 2
ORDER BY COLAB.NOME, DEPENDENTES DESC

~~~~~~~~~~

SELECT CPF,nome,data_nascimento,parentesco,colaborador,floor((SYSDATE - BRH.DEPENDENTE.DATA_NASCIMENTO)/365.0) AS IDADE, 
(CASE WHEN (SYSDATE - BRH.DEPENDENTE.DATA_NASCIMENTO)/365 < 18 THEN 'Menor de Idade'
ELSE 'Maior de Idade'
END)AS Faixa_Etaria
FROM BRH.DEPENDENTE
ORDER BY COLABORADOR,NOME

~~~~~~~~~~
CREATE OR REPLACE VIEW BRH.VW_DEP AS
SELECT CPF,nome as nome_dep,data_nascimento,parentesco,colaborador, floor((SYSDATE - BRH.DEPENDENTE.DATA_NASCIMENTO)/365.0) AS IDADE, 
(CASE WHEN (SYSDATE - BRH.DEPENDENTE.DATA_NASCIMENTO)/365 < 18 THEN 'Menor de Idade'
ELSE 'Maior de Idade'
END)AS Faixa_Etaria
FROM BRH.DEPENDENTE
ORDER BY COLABORADOR,NOME

~~~~~~~~~~

SELECT COLABORADOR, SUM(VALOR) AS TOTAL FROM (
SELECT D.COLABORADOR,100 AS VALOR
FROM BRH.VW_DEP D
WHERE D.PARENTESCO = 'Cônjuge'
UNION
SELECT D.COLABORADOR, 50 AS VALOR
FROM BRH.VW_DEP D
WHERE D.PARENTESCO = 'Filho(a)' AND D.FAIXA_ETARIA = 'Maior de Idade'
UNION ALL
SELECT D.COLABORADOR, 25 AS VALOR
FROM BRH.VW_DEP D
WHERE D.PARENTESCO = 'Filho(a)' AND D.FAIXA_ETARIA = 'Menor de Idade'
UNION ALL
SELECT COLAB.MATRICULA,
CASE
WHEN COLAB.SALARIO <3000 THEN COLAB.SALARIO * 0.01
WHEN COLAB.SALARIO <=6000 THEN COLAB.SALARIO * 0.02
WHEN COLAB.SALARIO <=20000 THEN COLAB.SALARIO * 0.03
ELSE COLAB.SALARIO * 0.05
END  
AS VALOR
FROM BRH.COLABORADOR COLAB
)
GROUP BY COLABORADOR
ORDER BY COLABORADOR

~~~~~~~~~~

SELECT * 
FROM (
SELECT ROWNUM AS NUMERO, COLAB.NOME
FROM  BRH.COLABORADOR COLAB
)PG
WHERE ROWNUM <11
ORDER BY NOME ;


SELECT * 
FROM (
SELECT ROWNUM AS NUMERO, COLAB.NOME
FROM  BRH.COLABORADOR COLAB
)PG
WHERE NUMERO > 10 AND NUMERO <= 20 
ORDER BY NOME ;


SELECT * 
FROM (
SELECT ROWNUM AS NUMERO, COLAB.NOME
FROM  BRH.COLABORADOR COLAB
)PG
WHERE NUMERO > 20 AND NUMERO <= 30 
ORDER BY NOME ;

~~~~~~~~~~

SELECT ATRIB.COLABORADOR, COUNT(ATRIB.PROJETO) AS PROJETOS
FROM BRH.ATRIBUICAO ATRIB
GROUP BY ATRIB.COLABORADOR
HAVING COUNT(ATRIB.PROJETO) = (SELECT COUNT(*) FROM BRH.PROJETO);

```

### Algumas  {c:purple}Procedures{/c} e  {c:gold}Functions{/c} relacionadas ao projeto BRH

```

SET SERVEROUTPUT ON;
1~~~~~~~~~~
CREATE OR REPLACE PROCEDURE BRH.INSERE_PROJETO(
P_NOME IN VARCHAR2,
P_RESPONSAVEL IN VARCHAR2,
P_INICIO IN DATE)
IS 
BEGIN
INSERT INTO BRH.PROJETO (NOME,RESPONSAVEL,INICIO) VALUES (P_NOME,UPPER(P_RESPONSAVEL),P_INICIO);
END;

EXECUTE BRH.INSERE_PROJETO('MCD','V123',SYSDATE);


2~~~~~~~~~~
CREATE OR REPLACE FUNCTION BRH.CALCULA_IDADE (
P_NASCIMENTO IN DATE
)
RETURN NUMBER
IS  
  P_IDADE NUMBER;
BEGIN
    P_IDADE := TRUNC((MONTHS_BETWEEN(SYSDATE, P_NASCIMENTO)/12));
    RETURN P_IDADE;
END;

DECLARE
   P_NASCIMENTO DATE := TO_DATE('03-07-1961','DD-MM-YYYY');
BEGIN
   DBMS_OUTPUT.PUT_LINE('A PESSOA TEM ' || BRH.CALCULA_IDADE(P_NASCIMENTO) || ' ANOS DE IDADE.' );
END;


4~~~~~~~~~~
CREATE OR REPLACE FUNCTION BRH.FINALIZA_PROJETO(
P_ID IN BRH.PROJETO.ID%TYPE)
RETURN BRH.PROJETO.FIM%TYPE
IS
P_FIM PROJETO.FIM%TYPE;
BEGIN
P_FIM := SYSDATE;
UPDATE BRH.PROJETO
SET FIM = P_FIM
WHERE ID = P_ID;
RETURN P_FIM;
END;

DECLARE
P_FIM DATE;
BEGIN
P_FIM := BRH.FINALIZA_PROJETO(1);
DBMS_OUTPUT.PUT_LINE('DATA DE TERMINO DO PROJETO É ' || P_FIM);
END;

SELECT * FROM BRH.PROJETO;

5~~~~~~~~~~
CREATE or replace PROCEDURE BRH.INSERE_PROJETO
(

P_NOME IN VARCHAR2,
P_RESPONSAVEL IN VARCHAR2,
P_INICIO IN DATE
)
IS 
BEGIN
INSERT INTO BRH.PROJETO (NOME,RESPONSAVEL,INICIO) VALUES (P_NOME,UPPER(P_RESPONSAVEL),P_INICIO);
IF LENGTH(P_NOME) < 2 OR LENGTH(P_NOME) = NULL THEN
     
        dbms_output.put_line( P_NOME || ' Nome de projeto inválido! Deve ter dois ou mais caracteres. ' );
    ELSE
        dbms_output.put_line('Cadastrado com Sucesso ' || P_NOME);
       
    END IF;
END;

EXECUTE BRH.INSERE_PROJETO ('X','V123',sysdate);
EXECUTE BRH.INSERE_PROJETO ('XX','V123',sysdate);

6~~~~~~~~~~
CREATE OR REPLACE FUNCTION BRH.CALCULA_IDADE (
P_NASCIMENTO IN DATE
)
RETURN NUMBER
IS  
  P_IDADE NUMBER;
BEGIN
     IF P_NASCIMENTO > SYSDATE OR P_NASCIMENTO = NULL THEN
       dbms_output.put_line('Impossível calcular idade! Data inválida: ' || P_NASCIMENTO);
    ELSE
      P_IDADE := TRUNC((MONTHS_BETWEEN(SYSDATE, P_NASCIMENTO)/12));
    END IF;
    RETURN P_IDADE;

END;

DECLARE
   P_NASCIMENTO DATE := TO_DATE('15-09-2022','DD-MM-YYYY');
BEGIN
 DBMS_OUTPUT.PUT_LINE(BRH.CALCULA_IDADE(P_NASCIMENTO) );
END;

DECLARE
   P_NASCIMENTO DATE := TO_DATE('03-07-1961','DD-MM-YYYY');
BEGIN
 DBMS_OUTPUT.PUT_LINE(BRH.CALCULA_IDADE(P_NASCIMENTO) );
END;

```
