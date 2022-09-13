
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