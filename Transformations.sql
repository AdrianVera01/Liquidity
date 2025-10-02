-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\0_raw.a000_LCR_Account_Mapping_SQLServer.sql
-- Converted from: "C:\Users ...\0_raw.a000_LCR_Account_Mapping.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.raw.yyy_30_BBVA_Financial_Statement_Additional
-- Please review especially WHERE clauses, joins, and date/boolean logic.


SELECT raw.a000_LCR_Account_Mapping.Sequence, raw.a000_LCR_Account_Mapping.LCR_account, raw.a000_LCR_Account_Mapping.[Group_2], raw.a000_LCR_Account_Mapping.[Product Number], raw.a000_LCR_Account_Mapping.[Is_Product Number_23000_23004], raw.a000_LCR_Account_Mapping.contract, raw.a000_LCR_Account_Mapping.KeyA, raw.a000_LCR_Account_Mapping.Any_Match, raw.a000_LCR_Account_Mapping.Sorgu_Final
FROM raw.a000_LCR_Account_Mapping
ORDER BY raw.a000_LCR_Account_Mapping.Sequence;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00100_a_Overwrite_Keys_SQLServer.sql
-- Converted from: "C:\Users ...\00100_a_Overwrite_Keys.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

UPDATE raw.yyy_30_BBVA_Financial_Statement_Additional SET raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account = Null
WHERE (((raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account) Is Not Null));


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00110_a_Update_Lookup_First_Mapping_SQLServer.sql
-- Converted from: "C:\Users ...\00110_a_Update_Lookup_First_Mapping.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

UPDATE raw.a000_LCR_Account_Mapping SET raw.a000_LCR_Account_Mapping.KeyA = (CASE WHEN [Group_2] Is Null THEN "*" ELSE [Group_2] END) + "_" + (CASE WHEN [Is_Product_Number_21095_21096] Is Null THEN "*" ELSE [Is_Product_Number_21095_21096] END) + "_" + (CASE WHEN [Product Number] Is Null THEN "*" ELSE [Product Number] END) + "_" + (CASE WHEN [Is_Product Number_23000_23004] Is Null THEN "*" ELSE [Is_Product Number_23000_23004] END) + "_" + (CASE WHEN [contract] Is Null THEN "*" ELSE [contract] END), raw.a000_LCR_Account_Mapping.Sorgu_Final = Null, raw.a000_LCR_Account_Mapping.Any_Match = Null;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00200_a_Mother_Data_First_Mapping_SQLServer.sql
-- Converted from: "C:\Users ...\00200_a_Mother_Data_First_Mapping.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

DELETE *
FROM yy_10_a_Mother_Data_First_Mapping;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00200_b_Mother_Data_First_Mapping_SQLServer.sql
-- Converted from: "C:\Users ...\00200_b_Mother_Data_First_Mapping.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

SELECT yyy_30_BBVA_Financial_Statement.[BBVA_Sequence Distinct], yyy_30_BBVA_Financial_Statement.group2 AS Group2_B, IIf([Product Number] In ("21095","21096"),"Yes","No") AS [Is_Product Number_21095_21096_B], yyy_30_BBVA_Financial_Statement.[Product Number] AS [Product Number_B], IIf([Product Number] In ("23000","23004"),"Yes","No") AS [Is_Product Number_23000_23004_B], yyy_30_BBVA_Financial_Statement.Contract AS Contract_B
FROM yyy_30_BBVA_Financial_Statement;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00200_c_Mother_Data_First_Mapping_SQLServer.sql
-- Converted from: "C:\Users ...\00200_c_Mother_Data_First_Mapping.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

INSERT INTO yy_10_a_Mother_Data_First_Mapping ( DATA_SequenceB, Keyb, Group2_B, [Is_Product Number_21095_21096_B], [Product Number_B], [Is_Product Number_23000_23004_B], Contract_B )
SELECT [00200_b_Mother_Data_First_Mapping].[BBVA_Sequence Distinct], [Group2_B] + "_" + [Is_Product Number_21095_21096_B] + "_" + [Product Number_B] + "_" + [Is_Product Number_23000_23004_B] + "_" + [Contract_B] AS Keyb, [00200_b_Mother_Data_First_Mapping].Group2_B, [00200_b_Mother_Data_First_Mapping].[Is_Product Number_21095_21096_B], [00200_b_Mother_Data_First_Mapping].[Product Number_B], [00200_b_Mother_Data_First_Mapping].[Is_Product Number_23000_23004_B], [00200_b_Mother_Data_First_Mapping].Contract_B
FROM 00200_b_Mother_Data_First_Mapping;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00210_a_Distinct_Mother_Data_First_Mapping_SQLServer.sql
-- Converted from: "C:\Users ...\00210_a_Distinct_Mother_Data_First_Mapping.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

DELETE *
FROM yy_10_b_Distinct_Mother_Data_First_Mapping;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00210_b_Distinct_Mother_Data_First_Mapping_SQLServer.sql
-- Converted from: "C:\Users ...\00210_b_Distinct_Mother_Data_First_Mapping.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

INSERT INTO yy_10_b_Distinct_Mother_Data_First_Mapping ( KeyC, Group2_C, [Is_Product Number_21095_21096_C], [Product Number_C], [Is_Product Number_23000_23004_C], Contract_C )
SELECT yy_10_a_Mother_Data_First_Mapping.Keyb, yy_10_a_Mother_Data_First_Mapping.Group2_B, yy_10_a_Mother_Data_First_Mapping.[Is_Product Number_21095_21096_B], yy_10_a_Mother_Data_First_Mapping.[Product Number_B], yy_10_a_Mother_Data_First_Mapping.[Is_Product Number_23000_23004_B], yy_10_a_Mother_Data_First_Mapping.Contract_B
FROM yy_10_a_Mother_Data_First_Mapping
GROUP BY yy_10_a_Mother_Data_First_Mapping.Keyb, yy_10_a_Mother_Data_First_Mapping.Group2_B, yy_10_a_Mother_Data_First_Mapping.[Is_Product Number_21095_21096_B], yy_10_a_Mother_Data_First_Mapping.[Product Number_B], yy_10_a_Mother_Data_First_Mapping.[Is_Product Number_23000_23004_B], yy_10_a_Mother_Data_First_Mapping.Contract_B;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00210_c_First_Mapping_DATA_UPDATE_SQLServer.sql
-- Converted from: "C:\Users ...\00210_c_First_Mapping_DATA_UPDATE.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

UPDATE raw.yyy_30_BBVA_Financial_Statement_Additional INNER JOIN ((yyy_30_BBVA_Financial_Statement INNER JOIN yy_10_a_Mother_Data_First_Mapping ON yyy_30_BBVA_Financial_Statement.[BBVA_Sequence Distinct] = yy_10_a_Mother_Data_First_Mapping.DATA_SequenceB) INNER JOIN yy_10_b_Distinct_Mother_Data_First_Mapping ON yy_10_a_Mother_Data_First_Mapping.Keyb = yy_10_b_Distinct_Mother_Data_First_Mapping.KeyC) ON raw.yyy_30_BBVA_Financial_Statement_Additional.[BBVA_Sequence Distinct] = yyy_30_BBVA_Financial_Statement.[BBVA_Sequence Distinct] SET raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account = [LCR_account_C]
WHERE (((yy_10_b_Distinct_Mother_Data_First_Mapping.LCR_account_C) Is Not Null));


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00750_a_yyy_90_LCR_DATA_SQLServer.sql
-- Converted from: "C:\Users ...\00750_a_yyy_90_LCR_DATA.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

DELETE *
FROM yyy_90_LCR_DATA;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00750_b_yyy_90_LCR_DATA_SQLServer.sql
-- Converted from: "C:\Users ...\00750_b_yyy_90_LCR_DATA.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

INSERT INTO yyy_90_LCR_DATA ( period, entity_code, [Related Breakdown Number], Chart, Account, currencyaa, country, [counterparty country], intercompany_codea, ITEM, ITEM_CODE, Link, Amount1, Amount2, Amount3, Amount4, Amount5, Amount6, Amount7, Amount8, Amount9, Amount10, Amount11, Amount12, Amount13, Amount14, Amount15, Amount16, Amount17, Amount18 )
SELECT Year([date]) + FORMAT(Month([date]), '00') AS period, 70501 AS entity_code, "000001" AS [Related Breakdown Number], "M8" AS Chart, raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account AS Account, IIf([Currency] In ("EUR","USD","TRY","MXN","GBP"),[Currency],"RES") AS currencyaa, String(2," ") AS country, String(2," ") AS [counterparty country], IIf([intercompany_code] Is Null,String(5," "),[intercompany_code]) AS intercompany_codea, (CASE WHEN [Maturity Date] Is Not Null Or [contract]="Card no. 8904" THEN 'VCT2' ELSE String(4," " END)) AS ITEM, IIf([contract]="Card no. 8904","0003" + String(16," "),IIf([Maturity Date] Is Null,String(20," "),IIf([Maturity Date]-[Date]<=184,'0001' + String(16," "),IIf([Maturity Date]-[Date]<=365,'0002' + String(16," "),IIf([Maturity Date]-[Date]>365,'0003' + String(16," ")))))) AS ITEM_CODE, String(11,"0") AS Link, 0 AS Amount1, Sum(IIf([FINREP Sector] In ("GG"),1,0)*[Principle (Eur)]) AS Amount2, Sum(IIf([FINREP Sector] In ("CI"),1,0)*[Principle (Eur)]) AS Amount3, 0 AS Amount4, 0 AS Amount5, 0 AS Amount6, 0 AS Amount7, Sum(IIf([FINREP Sector] In ("OFC"),1,0)*[Principle (Eur)]) AS Amount8, 0 AS Amount9, Sum(IIf([FINREP Sector] In ("NFC"),1,0)*IIf([Industry Number] Is Null Or [Industry Number] Not In ("2500"),1,0)*[Principle (Eur)]) AS Amount10, 0 AS Amount11, Sum(IIf([FINREP Sector] In ("NFC"),1,0)*IIf([Industry Number] In ("2500"),1,0)*[Principle (Eur)]) AS Amount12, Sum(IIf([FINREP Sector] In ("Households"),1,0)*[Principle (Eur)]) AS Amount13, 0 AS Amount14, 0 AS Amount15, 0 AS Amount16, 0 AS Amount17, 0 AS Amount18
FROM yyy_30_BBVA_Financial_Statement INNER JOIN raw.yyy_30_BBVA_Financial_Statement_Additional ON yyy_30_BBVA_Financial_Statement.[BBVA_Sequence Distinct] = raw.yyy_30_BBVA_Financial_Statement_Additional.[BBVA_Sequence Distinct]
WHERE (((raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account) Is Not Null))
GROUP BY Year([date]) + FORMAT(Month([date]), '00'), raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account, IIf([Currency] In ("EUR","USD","TRY","MXN","GBP"),[Currency],"RES"), IIf([intercompany_code] Is Null,String(5," "),[intercompany_code]), (CASE WHEN [Maturity Date] Is Not Null Or [contract]="Card no. 8904" THEN 'VCT2' ELSE String(4," " END)), IIf([contract]="Card no. 8904","0003" + String(16," "),IIf([Maturity Date] Is Null,String(20," "),IIf([Maturity Date]-[Date]<=184,'0001' + String(16," "),IIf([Maturity Date]-[Date]<=365,'0002' + String(16," "),IIf([Maturity Date]-[Date]>365,'0003' + String(16," "))))));


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00750_c_yyy_90_LCR_DATA_Totals_SQLServer.sql
-- Converted from: "C:\Users ...\00750_c_yyy_90_LCR_DATA_Totals.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

UPDATE yyy_90_LCR_DATA SET yyy_90_LCR_DATA.Amount9 = [amount5]+[amount6]+[amount7]+[amount8], yyy_90_LCR_DATA.Amount14 = [amount1]+[amount2]+[amount3]+[amount4]+([amount5]+[amount6]+[amount7]+[amount8])+[amount10]+[amount11]+[amount12]+[amount13];


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00750_k01_Manual_Input_From_Jean_Paul_SQLServer.sql
-- Converted from: "C:\Users ...\00750_k01_Manual_Input_From_Jean_Paul.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

SELECT b001_Manual_Input_From_Jean_Paul.Account, "EUR" AS Currency1, Sum(b001_Manual_Input_From_Jean_Paul.Amount) AS SumOfAmount
FROM b001_Manual_Input_From_Jean_Paul
GROUP BY b001_Manual_Input_From_Jean_Paul.Account;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00750_k02_Manual_Input_From_Jean_Paul_SQLServer.sql
-- Converted from: "C:\Users ...\00750_k02_Manual_Input_From_Jean_Paul.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

INSERT INTO yyy_90_LCR_DATA ( period, entity_code, [Related Breakdown Number], Chart, Account, currencyaa, country, [counterparty country], intercompany_codea, ITEM, ITEM_CODE, Link, Amount14 )
SELECT b001_Manual_Input_From_Jean_Paul_MODEL.period, b001_Manual_Input_From_Jean_Paul_MODEL.entity_code, b001_Manual_Input_From_Jean_Paul_MODEL.[Related Breakdown Number], b001_Manual_Input_From_Jean_Paul_MODEL.Chart, [00750_k01_Manual_Input_From_Jean_Paul].Account, [00750_k01_Manual_Input_From_Jean_Paul].Currency1, b001_Manual_Input_From_Jean_Paul_MODEL.country, b001_Manual_Input_From_Jean_Paul_MODEL.[counterparty country], b001_Manual_Input_From_Jean_Paul_MODEL.intercompany_codea, b001_Manual_Input_From_Jean_Paul_MODEL.ITEM, b001_Manual_Input_From_Jean_Paul_MODEL.ITEM_CODE, b001_Manual_Input_From_Jean_Paul_MODEL.Link, [00750_k01_Manual_Input_From_Jean_Paul].SumOfAmount
FROM 00750_k01_Manual_Input_From_Jean_Paul, b001_Manual_Input_From_Jean_Paul_MODEL;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00760_a_yyy_92_LCR_DATA_SQLServer.sql
-- Converted from: "C:\Users ...\00760_a_yyy_92_LCR_DATA.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

DELETE *
FROM yyy_92_LCR_DATA;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00760_b_yyy_92_LCR_DATA_SQLServer.sql
-- Converted from: "C:\Users ...\00760_b_yyy_92_LCR_DATA.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

INSERT INTO yyy_92_LCR_DATA ( period, entity_code, [Related Breakdown Number], Chart, Account, currencyaa, country, [counterparty country], intercompany_codea, ITEM, ITEM_CODE, Link, Amount1, Amount2, Amount3, Amount4, Amount5, Amount6, Amount7, Amount8, Amount9, Amount10, Amount11, Amount12, Amount13, Amount14, Amount15, Amount16, Amount17, Amount18 )
SELECT yyy_90_LCR_DATA.period, yyy_90_LCR_DATA.entity_code, yyy_90_LCR_DATA.[Related Breakdown Number], yyy_90_LCR_DATA.Chart, yyy_90_LCR_DATA.Account, yyy_90_LCR_DATA.currencyaa, yyy_90_LCR_DATA.country, yyy_90_LCR_DATA.[counterparty country], yyy_90_LCR_DATA.intercompany_codea, yyy_90_LCR_DATA.ITEM, yyy_90_LCR_DATA.ITEM_CODE, yyy_90_LCR_DATA.Link, yyy_90_LCR_DATA.Amount1 AS Amount1a, yyy_90_LCR_DATA.Amount2 AS Amount2a, yyy_90_LCR_DATA.Amount3 AS Amount3a, yyy_90_LCR_DATA.Amount4 AS Amount4a, yyy_90_LCR_DATA.Amount5 AS Amount5a, yyy_90_LCR_DATA.Amount6 AS Amount6a, yyy_90_LCR_DATA.Amount7 AS Amount7a, yyy_90_LCR_DATA.Amount8 AS Amount8a, yyy_90_LCR_DATA.Amount9 AS Amount9a, yyy_90_LCR_DATA.Amount10 AS Amount10a, yyy_90_LCR_DATA.Amount11 AS Amount11a, yyy_90_LCR_DATA.Amount12 AS Amount12a, yyy_90_LCR_DATA.Amount13 AS Amount13a, yyy_90_LCR_DATA.Amount14 AS Amount14a, yyy_90_LCR_DATA.Amount15 AS Amount15a, yyy_90_LCR_DATA.Amount16 AS Amount16a, yyy_90_LCR_DATA.Amount17 AS Amount17a, yyy_90_LCR_DATA.Amount18 AS Amount18a
FROM yyy_90_LCR_DATA;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00760_c_yyy_92_LCR_DATA_Update_Nulls_SQLServer.sql
-- Converted from: "C:\Users ...\00760_c_yyy_92_LCR_DATA_Update_Nulls.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

UPDATE yyy_92_LCR_DATA SET yyy_92_LCR_DATA.Amount1 = (CASE WHEN [Amount1] Is Null THEN 0 ELSE [Amount1] END), yyy_92_LCR_DATA.Amount2 = (CASE WHEN [Amount2] Is Null THEN 0 ELSE [Amount2] END), yyy_92_LCR_DATA.Amount3 = (CASE WHEN [Amount3] Is Null THEN 0 ELSE [Amount3] END), yyy_92_LCR_DATA.Amount4 = (CASE WHEN [Amount4] Is Null THEN 0 ELSE [Amount4] END), yyy_92_LCR_DATA.Amount5 = (CASE WHEN [Amount5] Is Null THEN 0 ELSE [Amount5] END), yyy_92_LCR_DATA.Amount6 = (CASE WHEN [Amount6] Is Null THEN 0 ELSE [Amount6] END), yyy_92_LCR_DATA.Amount7 = (CASE WHEN [Amount7] Is Null THEN 0 ELSE [Amount7] END), yyy_92_LCR_DATA.Amount8 = (CASE WHEN [Amount8] Is Null THEN 0 ELSE [Amount8] END), yyy_92_LCR_DATA.Amount9 = (CASE WHEN [Amount9] Is Null THEN 0 ELSE [Amount9] END), yyy_92_LCR_DATA.Amount10 = (CASE WHEN [Amount10] Is Null THEN 0 ELSE [Amount10] END), yyy_92_LCR_DATA.Amount11 = (CASE WHEN [Amount11] Is Null THEN 0 ELSE [Amount11] END), yyy_92_LCR_DATA.Amount12 = (CASE WHEN [Amount12] Is Null THEN 0 ELSE [Amount12] END), yyy_92_LCR_DATA.Amount13 = (CASE WHEN [Amount13] Is Null THEN 0 ELSE [Amount13] END), yyy_92_LCR_DATA.Amount14 = (CASE WHEN [Amount14] Is Null THEN 0 ELSE [Amount14] END), yyy_92_LCR_DATA.Amount15 = (CASE WHEN [Amount15] Is Null THEN 0 ELSE [Amount15] END), yyy_92_LCR_DATA.Amount16 = (CASE WHEN [Amount16] Is Null THEN 0 ELSE [Amount16] END), yyy_92_LCR_DATA.Amount17 = (CASE WHEN [Amount17] Is Null THEN 0 ELSE [Amount17] END), yyy_92_LCR_DATA.Amount18 = (CASE WHEN [Amount18] Is Null THEN 0 ELSE [Amount18] END);


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00760_d_yyy_90_LCR_DATA_Update_Is_Zero_SQLServer.sql
-- Converted from: "C:\Users ...\00760_d_yyy_90_LCR_DATA_Update_Is_Zero.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

UPDATE yyy_92_LCR_DATA SET yyy_92_LCR_DATA.IsZero = "YES"
WHERE (((yyy_92_LCR_DATA.Amount1)=0) AND ((yyy_92_LCR_DATA.Amount2)=0) AND ((yyy_92_LCR_DATA.Amount3)=0) AND ((yyy_92_LCR_DATA.Amount4)=0) AND ((yyy_92_LCR_DATA.Amount5)=0) AND ((yyy_92_LCR_DATA.Amount6)=0) AND ((yyy_92_LCR_DATA.Amount7)=0) AND ((yyy_92_LCR_DATA.Amount8)=0) AND ((yyy_92_LCR_DATA.Amount9)=0) AND ((yyy_92_LCR_DATA.Amount10)=0) AND ((yyy_92_LCR_DATA.Amount11)=0) AND ((yyy_92_LCR_DATA.Amount12)=0) AND ((yyy_92_LCR_DATA.Amount13)=0) AND ((yyy_92_LCR_DATA.Amount14)=0) AND ((yyy_92_LCR_DATA.Amount15)=0) AND ((yyy_92_LCR_DATA.Amount16)=0) AND ((yyy_92_LCR_DATA.Amount17)=0) AND ((yyy_92_LCR_DATA.Amount18)=0));


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00770_a_yyy_95_LCR_DATA_FINAL_SQLServer.sql
-- Converted from: "C:\Users ...\00770_a_yyy_95_LCR_DATA_FINAL.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

SELECT yyy_92_LCR_DATA.period, yyy_92_LCR_DATA.entity_code, yyy_92_LCR_DATA.[Related Breakdown Number], yyy_92_LCR_DATA.Chart, yyy_92_LCR_DATA.Account, yyy_92_LCR_DATA.currencyaa, yyy_92_LCR_DATA.country, yyy_92_LCR_DATA.[counterparty country], yyy_92_LCR_DATA.intercompany_codea, yyy_92_LCR_DATA.ITEM, yyy_92_LCR_DATA.ITEM_CODE, yyy_92_LCR_DATA.Link, Format(Abs([amount1]),String(18,"0")) AS [amount 1], "+" AS [Sign of Amount 1], Format(Abs([amount2]),String(18,"0")) AS [amount 2], "+" AS [Sign of Amount 2], Format(Abs([amount3]),String(18,"0")) AS [amount 3], "+" AS [Sign of Amount 3], Format(Abs([amount4]),String(18,"0")) AS [amount 4], "+" AS [Sign of Amount 4], Format(Abs([amount5]),String(18,"0")) AS [amount 5], "+" AS [Sign of Amount 5], Format(Abs([amount6]),String(18,"0")) AS [amount 6], "+" AS [Sign of Amount 6], Format(Abs([amount7]),String(18,"0")) AS [amount 7], "+" AS [Sign of Amount 7], Format(Abs([amount8]),String(18,"0")) AS [amount 8], "+" AS [Sign of Amount 8], Format(Abs([amount9]),String(18,"0")) AS [amount 9], "+" AS [Sign of Amount 9], Format(Abs([amount10]),String(18,"0")) AS [amount 10], "+" AS [Sign of Amount 10], Format(Abs([amount11]),String(18,"0")) AS [amount 11], "+" AS [Sign of Amount 11], Format(Abs([amount12]),String(18,"0")) AS [amount 12], "+" AS [Sign of Amount 12], Format(Abs([amount13]),String(18,"0")) AS [amount 13], "+" AS [Sign of Amount 13], Format(Abs([amount14]),String(18,"0")) AS [amount 14], "+" AS [Sign of Amount 14], Format(Abs([amount15]),String(18,"0")) AS [amount 15], "+" AS [Sign of Amount 15], Format(Abs([amount16]),String(18,"0")) AS [amount 16], "+" AS [Sign of Amount 16], Format(Abs([amount17]),String(18,"0")) AS [amount 17], "+" AS [Sign of Amount 17], Format(Abs([amount18]),String(18,"0")) AS [amount 18], "+" AS [Sign of Amount 18], yyy_92_LCR_DATA.IsZero
FROM yyy_92_LCR_DATA
WHERE (((yyy_92_LCR_DATA.IsZero)="NO"));


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00770_b_yyy_95_LCR_DATA_FINAL_SQLServer.sql
-- Converted from: "C:\Users ...\00770_b_yyy_95_LCR_DATA_FINAL.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

DELETE *
FROM yyy_95_LCR_DATA_FINAL;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00770_c_yyy_95_LCR_DATA_FINAL_SQLServer.sql
-- Converted from: "C:\Users ...\00770_c_yyy_95_LCR_DATA_FINAL.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

INSERT INTO yyy_95_LCR_DATA_FINAL ( period, entity_code, [Related Breakdown Number], Chart, Account, currencyaa, country, [counterparty country], intercompany_codea, ITEM, ITEM_CODE, Link, [amount 1], [Sign of Amount 1], [amount 2], [Sign of Amount 2], [amount 3], [Sign of Amount 3], [amount 4], [Sign of Amount 4], [amount 5], [Sign of Amount 5], [amount 6], [Sign of Amount 6], [amount 7], [Sign of Amount 7], [amount 8], [Sign of Amount 8], [amount 9], [Sign of Amount 9], [amount 10], [Sign of Amount 10], [amount 11], [Sign of Amount 11], [amount 12], [Sign of Amount 12], [amount 13], [Sign of Amount 13], [amount 14], [Sign of Amount 14], [amount 15], [Sign of Amount 15], [amount 16], [Sign of Amount 16], [amount 17], [Sign of Amount 17], [amount 18], [Sign of Amount 18], [Breakdown Description] )
SELECT [00770_a_yyy_95_LCR_DATA_FINAL].period, [00770_a_yyy_95_LCR_DATA_FINAL].entity_code, [00770_a_yyy_95_LCR_DATA_FINAL].[Related Breakdown Number], [00770_a_yyy_95_LCR_DATA_FINAL].Chart, [00770_a_yyy_95_LCR_DATA_FINAL].Account, [00770_a_yyy_95_LCR_DATA_FINAL].currencyaa, [00770_a_yyy_95_LCR_DATA_FINAL].country, [00770_a_yyy_95_LCR_DATA_FINAL].[counterparty country], [00770_a_yyy_95_LCR_DATA_FINAL].intercompany_codea, [00770_a_yyy_95_LCR_DATA_FINAL].ITEM, [00770_a_yyy_95_LCR_DATA_FINAL].ITEM_CODE, [00770_a_yyy_95_LCR_DATA_FINAL].Link, [00770_a_yyy_95_LCR_DATA_FINAL].[amount 1], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 1], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 2], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 2], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 3], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 3], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 4], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 4], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 5], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 5], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 6], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 6], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 7], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 7], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 8], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 8], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 9], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 9], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 10], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 10], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 11], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 11], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 12], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 12], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 13], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 13], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 14], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 14], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 15], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 15], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 16], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 16], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 17], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 17], [00770_a_yyy_95_LCR_DATA_FINAL].[amount 18], [00770_a_yyy_95_LCR_DATA_FINAL].[Sign of Amount 18], String(60," ") AS Expr1
FROM 00770_a_yyy_95_LCR_DATA_FINAL;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00770_d_Total_Amount_Update_SQLServer.sql
-- Converted from: "C:\Users ...\00770_d_Total_Amount_Update.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

UPDATE yyy_95_LCR_DATA_FINAL SET yyy_95_LCR_DATA_FINAL.[Amount 9] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 9] = "+", yyy_95_LCR_DATA_FINAL.[Amount 14] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 14] = "+"
WHERE (((yyy_95_LCR_DATA_FINAL.Account) Like "11%"));


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00770_e_Breakdown_Amount_Update_SQLServer.sql
-- Converted from: "C:\Users ...\00770_e_Breakdown_Amount_Update.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

UPDATE yyy_95_LCR_DATA_FINAL SET yyy_95_LCR_DATA_FINAL.[Amount 1] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 1] = "+", yyy_95_LCR_DATA_FINAL.[Amount 2] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 2] = "+", yyy_95_LCR_DATA_FINAL.[Amount 3] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 3] = "+", yyy_95_LCR_DATA_FINAL.[Amount 4] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 4] = "+", yyy_95_LCR_DATA_FINAL.[Amount 5] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 5] = "+", yyy_95_LCR_DATA_FINAL.[Amount 6] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 6] = "+", yyy_95_LCR_DATA_FINAL.[Amount 7] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 7] = "+", yyy_95_LCR_DATA_FINAL.[Amount 8] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 8] = "+", yyy_95_LCR_DATA_FINAL.[Amount 9] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 9] = "+", yyy_95_LCR_DATA_FINAL.[Amount 10] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 10] = "+", yyy_95_LCR_DATA_FINAL.[Amount 11] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 11] = "+", yyy_95_LCR_DATA_FINAL.[Amount 12] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 12] = "+", yyy_95_LCR_DATA_FINAL.[Amount 13] = "000000000000000000", yyy_95_LCR_DATA_FINAL.[Sign of Amount 13] = "+"
WHERE (((yyy_95_LCR_DATA_FINAL.Account) Not Like "11%"));


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\00780_a_yyy_95_LCR_DATA_FINAL_Len_concatenar_SQLServer.sql
-- Converted from: "C:\Users ...\00780_a_yyy_95_LCR_DATA_FINAL_Len_concatenar.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

UPDATE yyy_95_LCR_DATA_FINAL SET yyy_95_LCR_DATA_FINAL.concatenar = [period]&[entity_code]&[Related breakdown number]&[Chart]&[Account]&[currencyaa]&[country]&[counterparty country]&[intercompany_codea]&[ITEM]&[ITEM_CODE]&[Link]&[Amount 1]&[Sign of Amount 1]&[Amount 2]&[Sign of Amount 2]&[Amount 3]&[Sign of Amount 3]&[Amount 4]&[Sign of Amount 4]&[Amount 5]&[Sign of Amount 5]&[Amount 6]&[Sign of Amount 6]&[Amount 7]&[Sign of Amount 7]&[Amount 8]&[Sign of Amount 8]&[Amount 9]&[Sign of Amount 9]&[Amount 10]&[Sign of Amount 10]&[Amount 11]&[Sign of Amount 11]&[Amount 12]&[Sign of Amount 12]&[Amount 13]&[Sign of Amount 13]&[Amount 14]&[Sign of Amount 14]&[Amount 15]&[Sign of Amount 15]&[Amount 16]&[Sign of Amount 16]&[Amount 17]&[Sign of Amount 17]&[Amount 18]&[Sign of Amount 18]&[Amount 19]&[Sign of Amount 19]&[Amount 20]&[Sign of Amount 20]&[Amount 21]&[Sign of Amount 21]&[Amount 22]&[Sign of Amount 22]&[Amount 23]&[Sign of Amount 23]&[Amount 24]&[Sign of Amount 24]&[Amount 25]&[Sign of Amount 25]&[Amount 26]&[Sign of Amount 26]&[Amount 27]&[Sign of Amount 27]&[Porcentaje 1]&[Sign of Porcentaje 1]&[Porcentaje 2]&[Sign of Porcentaje 2]&[Porcentaje 3]&[Sign of Porcentaje 3]&[Porcentaje 4]&[Sign of Porcentaje 4]&[Porcentaje 5]&[Sign of Porcentaje 5]&[Porcentaje 6]&[Sign of Porcentaje 6]&[Porcentaje 7]&[Sign of Porcentaje 7]&[Breakdown Description], yyy_95_LCR_DATA_FINAL.length_concatenar = len([period]&[entity_code]&[Related breakdown number]&[Chart]&[Account]&[currencyaa]&[country]&[counterparty country]&[intercompany_codea]&[ITEM]&[ITEM_CODE]&[Link]&[Amount 1]&[Sign of Amount 1]&[Amount 2]&[Sign of Amount 2]&[Amount 3]&[Sign of Amount 3]&[Amount 4]&[Sign of Amount 4]&[Amount 5]&[Sign of Amount 5]&[Amount 6]&[Sign of Amount 6]&[Amount 7]&[Sign of Amount 7]&[Amount 8]&[Sign of Amount 8]&[Amount 9]&[Sign of Amount 9]&[Amount 10]&[Sign of Amount 10]&[Amount 11]&[Sign of Amount 11]&[Amount 12]&[Sign of Amount 12]&[Amount 13]&[Sign of Amount 13]&[Amount 14]&[Sign of Amount 14]&[Amount 15]&[Sign of Amount 15]&[Amount 16]&[Sign of Amount 16]&[Amount 17]&[Sign of Amount 17]&[Amount 18]&[Sign of Amount 18]&[Amount 19]&[Sign of Amount 19]&[Amount 20]&[Sign of Amount 20]&[Amount 21]&[Sign of Amount 21]&[Amount 22]&[Sign of Amount 22]&[Amount 23]&[Sign of Amount 23]&[Amount 24]&[Sign of Amount 24]&[Amount 25]&[Sign of Amount 25]&[Amount 26]&[Sign of Amount 26]&[Amount 27]&[Sign of Amount 27]&[Porcentaje 1]&[Sign of Porcentaje 1]&[Porcentaje 2]&[Sign of Porcentaje 2]&[Porcentaje 3]&[Sign of Porcentaje 3]&[Porcentaje 4]&[Sign of Porcentaje 4]&[Porcentaje 5]&[Sign of Porcentaje 5]&[Porcentaje 6]&[Sign of Porcentaje 6]&[Porcentaje 7]&[Sign of Porcentaje 7]&[Breakdown Description]);


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\9999_ROW_SIRASI_ICIN_SQLServer.sql
-- Converted from: "C:\Users ...\9999_ROW_SIRASI_ICIN.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

SELECT yyy_95_LCR_DATA_FINAL.period, yyy_95_LCR_DATA_FINAL.entity_code, yyy_95_LCR_DATA_FINAL.[Related breakdown number], yyy_95_LCR_DATA_FINAL.Chart, yyy_95_LCR_DATA_FINAL.Account, yyy_95_LCR_DATA_FINAL.currencyaa, yyy_95_LCR_DATA_FINAL.country, yyy_95_LCR_DATA_FINAL.[counterparty country], yyy_95_LCR_DATA_FINAL.intercompany_codea, yyy_95_LCR_DATA_FINAL.ITEM, yyy_95_LCR_DATA_FINAL.ITEM_CODE, yyy_95_LCR_DATA_FINAL.Link, yyy_95_LCR_DATA_FINAL.[Amount 1], yyy_95_LCR_DATA_FINAL.[Sign of Amount 1], yyy_95_LCR_DATA_FINAL.[Amount 2], yyy_95_LCR_DATA_FINAL.[Sign of Amount 2], yyy_95_LCR_DATA_FINAL.[Amount 3], yyy_95_LCR_DATA_FINAL.[Sign of Amount 3], yyy_95_LCR_DATA_FINAL.[Amount 4], yyy_95_LCR_DATA_FINAL.[Sign of Amount 4], yyy_95_LCR_DATA_FINAL.[Amount 5], yyy_95_LCR_DATA_FINAL.[Sign of Amount 5], yyy_95_LCR_DATA_FINAL.[Amount 6], yyy_95_LCR_DATA_FINAL.[Sign of Amount 6], yyy_95_LCR_DATA_FINAL.[Amount 7], yyy_95_LCR_DATA_FINAL.[Sign of Amount 7], yyy_95_LCR_DATA_FINAL.[Amount 8], yyy_95_LCR_DATA_FINAL.[Sign of Amount 8], yyy_95_LCR_DATA_FINAL.[Amount 9], yyy_95_LCR_DATA_FINAL.[Sign of Amount 9], yyy_95_LCR_DATA_FINAL.[Amount 10], yyy_95_LCR_DATA_FINAL.[Sign of Amount 10], yyy_95_LCR_DATA_FINAL.[Amount 11], yyy_95_LCR_DATA_FINAL.[Sign of Amount 11], yyy_95_LCR_DATA_FINAL.[Amount 12], yyy_95_LCR_DATA_FINAL.[Sign of Amount 12], yyy_95_LCR_DATA_FINAL.[Amount 13], yyy_95_LCR_DATA_FINAL.[Sign of Amount 13], yyy_95_LCR_DATA_FINAL.[Amount 14], yyy_95_LCR_DATA_FINAL.[Sign of Amount 14], yyy_95_LCR_DATA_FINAL.[Amount 15], yyy_95_LCR_DATA_FINAL.[Sign of Amount 15], yyy_95_LCR_DATA_FINAL.[Amount 16], yyy_95_LCR_DATA_FINAL.[Sign of Amount 16], yyy_95_LCR_DATA_FINAL.[Amount 17], yyy_95_LCR_DATA_FINAL.[Sign of Amount 17], yyy_95_LCR_DATA_FINAL.[Amount 18], yyy_95_LCR_DATA_FINAL.[Sign of Amount 18], yyy_95_LCR_DATA_FINAL.[Amount 19], yyy_95_LCR_DATA_FINAL.[Sign of Amount 19], yyy_95_LCR_DATA_FINAL.[Amount 20], yyy_95_LCR_DATA_FINAL.[Sign of Amount 20], yyy_95_LCR_DATA_FINAL.[Amount 21], yyy_95_LCR_DATA_FINAL.[Sign of Amount 21], yyy_95_LCR_DATA_FINAL.[Amount 22], yyy_95_LCR_DATA_FINAL.[Sign of Amount 22], yyy_95_LCR_DATA_FINAL.[Amount 23], yyy_95_LCR_DATA_FINAL.[Sign of Amount 23], yyy_95_LCR_DATA_FINAL.[Amount 24], yyy_95_LCR_DATA_FINAL.[Sign of Amount 24], yyy_95_LCR_DATA_FINAL.[Amount 25], yyy_95_LCR_DATA_FINAL.[Sign of Amount 25], yyy_95_LCR_DATA_FINAL.[Amount 26], yyy_95_LCR_DATA_FINAL.[Sign of Amount 26], yyy_95_LCR_DATA_FINAL.[Amount 27], yyy_95_LCR_DATA_FINAL.[Sign of Amount 27], yyy_95_LCR_DATA_FINAL.[Porcentaje 1], yyy_95_LCR_DATA_FINAL.[Sign of Porcentaje 1], yyy_95_LCR_DATA_FINAL.[Porcentaje 2], yyy_95_LCR_DATA_FINAL.[Sign of Porcentaje 2], yyy_95_LCR_DATA_FINAL.[Porcentaje 3], yyy_95_LCR_DATA_FINAL.[Sign of Porcentaje 3], yyy_95_LCR_DATA_FINAL.[Porcentaje 4], yyy_95_LCR_DATA_FINAL.[Sign of Porcentaje 4], yyy_95_LCR_DATA_FINAL.[Porcentaje 5], yyy_95_LCR_DATA_FINAL.[Sign of Porcentaje 5], yyy_95_LCR_DATA_FINAL.[Porcentaje 6], yyy_95_LCR_DATA_FINAL.[Sign of Porcentaje 6], yyy_95_LCR_DATA_FINAL.[Porcentaje 7], yyy_95_LCR_DATA_FINAL.[Sign of Porcentaje 7], yyy_95_LCR_DATA_FINAL.[Breakdown Description], yyy_95_LCR_DATA_FINAL.concatenar, yyy_95_LCR_DATA_FINAL.length_concatenar
FROM yyy_95_LCR_DATA_FINAL
ORDER BY yyy_95_LCR_DATA_FINAL.period, yyy_95_LCR_DATA_FINAL.entity_code, yyy_95_LCR_DATA_FINAL.[Related breakdown number], yyy_95_LCR_DATA_FINAL.Chart, yyy_95_LCR_DATA_FINAL.Account, yyy_95_LCR_DATA_FINAL.currencyaa, yyy_95_LCR_DATA_FINAL.country, yyy_95_LCR_DATA_FINAL.[counterparty country], yyy_95_LCR_DATA_FINAL.intercompany_codea, yyy_95_LCR_DATA_FINAL.ITEM, yyy_95_LCR_DATA_FINAL.ITEM_CODE, yyy_95_LCR_DATA_FINAL.Link;


-- File: C:\Users\adria\Downloads\converted_sqlserver_queries\_C_\Users\Query1_SQLServer.sql
-- Converted from: "C:\Users ...\Query1.sql
-- NOTE: Automated best-effort conversion from Access to SQL Server.
-- Please review especially WHERE clauses, joins, and date/boolean logic.

SELECT yyy_90_LCR_DATA.Account, yyy_90_LCR_DATA.currencyaa, b001_Manual_Input_From_Jean_Paul.Amount
FROM yyy_90_LCR_DATA INNER JOIN b001_Manual_Input_From_Jean_Paul ON (yyy_90_LCR_DATA.Account = b001_Manual_Input_From_Jean_Paul.Account) AND (yyy_90_LCR_DATA.currencyaa = b001_Manual_Input_From_Jean_Paul.Currency);


