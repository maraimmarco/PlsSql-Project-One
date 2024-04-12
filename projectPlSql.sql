set serveroutput on 
create or replace Function YearDifference(startDate Date , endDate Date , payment varchar2 )
return number 
is 
  diff_between number (4);
begin 
    if payment = 'QUARTER' then
        diff_between := TRUNC (MONTHS_BETWEEN   (startDate ,endDate)/3 );
      elsif payment ='ANNUAL' then
        diff_between := TRUNC (MONTHS_BETWEEN   (startDate ,endDate)/12);
      elsif payment ='HALF_ANNUAL' then 
            diff_between := TRUNC (MONTHS_BETWEEN   (startDate ,endDate)/6);
      else 
            diff_between := TRUNC (MONTHS_BETWEEN   (startDate ,endDate));
      end if ;
    return  diff_between;
end;
create or replace Function FirstDate (startDate date ,payment varchar2)
return DATE 
is 
    MonthDate DATE ;
begin 
    if payment ='QUARTER' then 
       MonthDate :=add_months(startDate,3);
     elsif payment='HALF_ANNUAL' then
        MonthDate :=add_months(startDate ,6);
     elsif payment = 'MONTHLY' then
        MonthDate :=add_months(startDate ,1);
     else
        MonthDate :=add_months(startDate,12);
     end if ;

     return MonthDate;
end ;

create or replace procedure insertData (p_contract_id Number ,p_INSTALLMENT_DATE DATE, p_INSTALLMENT_AMOUNT  NUMBER)
is
    v_installment_id HR.INSTALLMENTS_PAID.INSTALLMENT_ID%TYPE; 
begin
     v_installment_id := HR.INSTALLMENTS_PAID_SEQ.NEXTVAL;
    insert into HR.INSTALLMENTS_PAID(INSTALLMENT_ID ,CONTRACT_ID,INSTALLMENT_DATE,INSTALLMENT_AMOUNT,paid )
    values (v_installment_id,p_contract_id,p_INSTALLMENT_DATE, p_INSTALLMENT_AMOUNT,0);
end;
show errors ;
set serveroutput on 
declare 
       CURSOR contractCursor IS
        SELECT CONTRACT_ID ,CONTRACT_STARTDATE , CONTRACT_ENDDATE , CONTRACT_PAYMENT_TYPE ,CONTRACT_TOTAL_FEES, NVL(CONTRACT_DEPOSIT_FEES ,0) as CONTRACT_DEPOSIT_FEES
        FROM HR.CONTRACTS ;
    startDate HR.CONTRACTS.CONTRACT_STARTDATE%TYPE;
    diff_between Number (10);
    finalFees Number (10);
    contractTotal Number (10);
    date_contract date;
begin
    for contractCur in contractCursor loop 
        finalFees :=contractCur.CONTRACT_TOTAL_FEES  - contractCur.CONTRACT_DEPOSIT_FEES;
        diff_between := YearDifference(contractCur.CONTRACT_ENDDATE ,contractCur.CONTRACT_STARTDATE,contractCur.CONTRACT_PAYMENT_TYPE);
        contractTotal :=finalFees / diff_between ;
       WHILE contractCur.CONTRACT_STARTDATE <contractCur.CONTRACT_ENDDATE LOOP
                date_contract := FirstDate(contractCur.CONTRACT_STARTDATE, contractCur.CONTRACT_PAYMENT_TYPE);
               -- DBMS_OUTPUT.PUT_LINE('Date of Fees: ' || TO_CHAR(date_contract, 'DD/MM/yyyy'));
                --DBMS_OUTPUT.PUT_LINE('startDate is ' || contractCur.CONTRACT_STARTDATE || ' and the end date is ' || contractCur.CONTRACT_ENDDATE || ' the difference between end years and start is ' || diff_between || ' contract is ' || contractTotal);
                insertData(contractCur.CONTRACT_ID,contractCur.CONTRACT_STARTDATE,contractTotal );
    contractCur.CONTRACT_STARTDATE := FirstDate(contractCur.CONTRACT_STARTDATE, contractCur.CONTRACT_PAYMENT_TYPE);
   END LOOP;
   
end loop;
   end ;
   select * 
   from HR.INSTALLMENTS_PAID;
   