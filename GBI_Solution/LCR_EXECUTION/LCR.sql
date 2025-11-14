USE GBI_LCR_EXECUTION


-- Q 01: 0_a000_LCR_account_Mapping --
/* It's just a query, but there is a table a000_LCR_account_Mapping. Maybe it is the same */ 
SELECT
    M.[Sequence],
    M.[LCR_account],
    M.[Group_2],
    M.[Product_Number],
    M.[Is_Product_Number_23000_23004],
    M.[contract],
    M.[KeyA],
    M.[Any_Match],[0_a000_LCR_account_Mapping]
    M.[Sorgu_Final]
INTO MIDTABLES.[0_a000_LCR_account_Mapping]
FROM INPUTS.[a000_LCR_Account_Mapping] AS M
ORDER BY
    M.[Sequence];


--Q 02: 00100_a_Overwrite_Keys -- 
UPDATE INPUTS.[yyy_30_BBVA_Financial_Statement_Additional]
SET INPUTS.[yyy_30_BBVA_Financial_Statement_Additional].Liquidity_LCR_Account = NULL
WHERE (((INPUTS.[yyy_30_BBVA_Financial_Statement_Additional].Liquidity_LCR_Account) IS NOT NULL));


-- Q 03:  00110_a_Update_Lookup_First_Mapping --
UPDATE INPUTS.[a000_LCR_Account_Mapping] 
SET INPUTS.[a000_LCR_Account_Mapping].KeyA = (CASE WHEN [Group_2] Is Null THEN '*' ELSE [Group_2] END) + '_' + (CASE WHEN [Is_Product_Number_21095_21096] Is Null THEN '*' ELSE [Is_Product_Number_21095_21096] END) + '_' + (CASE WHEN [Product_Number] Is Null THEN '*' ELSE [Product_Number] END) +  '_'  + (CASE WHEN [Is_Product_Number_23000_23004] Is Null THEN '*' ELSE [Is_Product_Number_23000_23004] END) +  '_'  + (CASE WHEN [contract] Is Null THEN '*' ELSE [contract] END), INPUTS.[a000_LCR_Account_Mapping].Sorgu_Final = Null, INPUTS.[a000_LCR_Account_Mapping].Any_Match = Null;

-- Q 04: 00200_a_Mother_Data_First_Mapping_SQLServer
-- DELETE FROM INPUTS.[yy_10_a_Mother_Data_First_Mapping];


-- Q 05 : 00200_b_Mother_Data_First_Mapping_SQLServer --
/* It is a Query for visualization */
SELECT
    F.[BBVA_Sequence_Distinct],
    F.[group2]                                    AS [Group2_B],
    CASE WHEN F.[Product_Number] IN ('21095','21096')
         THEN 'Yes' ELSE 'No' END                 AS [Is_Product_Number_21095_21096_B],
    F.[Product_Number]                            AS [Product_Number_B],
    CASE WHEN F.[Product_Number] IN ('23000','23004')
         THEN 'Yes' ELSE 'No' END                 AS [Is_Product_Number_23000_23004_B],
    F.[Contract]                                  AS [Contract_B]
INTO MIDTABLES.[00200_b_Mother_Data_First_Mapping]
FROM INPUTS.[yyy_30_BBVA_Financial_Statement] AS F;



-- Q06: 00200_c_Mother_Data_First_Mapping
INSERT INTO INPUTS.[yy_10_a_Mother_Data_First_Mapping] 
(
  DATA_SequenceB,
  Keyb,
  Group2_B,
  [Is_Product_Number_21095_21096_B],
  [Product_Number_B],
  [Is_Product_Number_23000_23004_B],
  Contract_B
)
SELECT
  CAST(b.[BBVA_Sequence_Distinct] AS nvarchar(50)),
  CAST(                          -- <-- force nvarchar(50)
    CONCAT_WS('_',
      CAST(b.[Group2_B]                                     AS nvarchar(100)),
      CAST(b.[Is_Product_Number_21095_21096_B]              AS nvarchar(100)),
      CAST(b.[Product_Number_B]                             AS nvarchar(100)),
      CAST(b.[Is_Product_Number_23000_23004_B]              AS nvarchar(100)),
      CAST(b.[Contract_B]                                   AS nvarchar(100))
    ) AS nvarchar(50)) AS Keyb,
  CAST(b.[Group2_B]                                         AS nvarchar(50)),
  CAST(b.[Is_Product_Number_21095_21096_B]                  AS nvarchar(50)),
  CAST(b.[Product_Number_B]                                 AS nvarchar(50)),
  CAST(b.[Is_Product_Number_23000_23004_B]                  AS nvarchar(50)),
  CAST(b.[Contract_B]                                       AS nvarchar(50)) 
FROM [MIDTABLES].[00200_b_Mother_Data_First_Mapping] AS b;

-- Q 07: 00210_a_Distinct_Mother_Data_First_Mapping --
-- DELETE FROM raw.[yy_10_b_Distinct_Mother_Data_First_Mapping];


-- Q 08: 00210_b_Distinct_Mother_Data_First_Mapping --
INSERT INTO INPUTS.[yy_10_b_Distinct_Mother_Data_First_Mapping]
( KeyC, Group2_C, [Is_Product_Number_21095_21096_C], [Product_Number_C], [Is_Product_Number_23000_23004_C], Contract_C )
SELECT DISTINCT Keyb,
Group2_B,
[Is_Product_Number_21095_21096_B],
[Product_Number_B],
[Is_Product_Number_23000_23004_B],
Contract_B
FROM INPUTS.yy_10_a_Mother_Data_First_Mapping
--GROUP BY Keyb, Group2_B, [Is_Product_Number_21095_21096_B], [Product_Number_B], [Is_Product_Number_23000_23004_B], Contract_B;

--  Q08.5 : Module A01_Primary() 
/* Here is used the module for updating the table, IDK why, but we have to */
ALTER TABLE [INPUTS].[yy_10_b_Distinct_Mother_Data_First_Mapping]
ADD
    -- change the names and types below to what you need
    Summary_KeyC            NVARCHAR(200)   NULL,
    LCR_account_C           INT             NULL,
    Any_Match               NVARCHAR(20)    NULL;

UPDATE d
SET d.Summary_KeyC = m.KeyA,
    d.LCR_account_C = m.LCR_account,
    d.Any_Match = 'Yes'
FROM [MIDTABLES].[yy_10_b_Distinct_Mother_Data_First_Mapping] d
INNER JOIN [MIDTABLES].[0_a000_LCR_Accounts_Mapping] m 
    ON d.KeyC LIKE m.KeyA
WHERE d.Summary_KeyC IS NULL;


-- Q 09: 00210_c_First_Mapping_DATA_UPDATE -- 
UPDATE FSA
SET FSA.[Liquidity_LCR_Account] = DMDFM.[LCR_account_C]
FROM INPUTS.[yyy_30_BBVA_Financial_Statement_Additional] AS FSA
INNER JOIN INPUTS.[yyy_30_BBVA_Financial_Statement]            AS FS
  ON FSA.[BBVA_Sequence_Distinct] = fs.[BBVA_Sequence_Distinct]
INNER JOIN INPUTS.[yy_10_a_Mother_Data_First_Mapping]          AS MDFM
  ON FS.[BBVA_Sequence_Distinct] = MDFM.[DATA_SequenceB]
INNER JOIN INPUTS.[yy_10_b_Distinct_Mother_Data_First_Mapping] AS DMDFM
  ON MDFM.[Keyb] = DMDFM.[KeyC]
WHERE DMDFM.[LCR_account_C] IS NOT NULL;


--Q 10: 00750_a_yyy_90_LCR_DATA--
-- It is uploaded for the structure. Changing the next query  00750_a_yyy_90_LCR_DATA wont be required as an Input 
-- DELETE FROM raw.[yyy_90_LCR_DATA]

-- Q 11: 00750_b_yyy_90_LCR_DATA: First version of Final LCR-- 
SELECT
    CONVERT(char(6), fs.[Date], 112)                            AS period,                     -- YYYYMM
    70501                                                       AS entity_code,
    N'000001'                                                   AS [Related_Breakdown_Number], -- SERGIO
    N'M8'                                                       AS Chart,
    fsa.[Liquidity_LCR_Account]                                AS Account,
  
    CASE WHEN fs.[Currency] IN (N'EUR',N'USD',N'TRY',N'MXN',N'GBP')
         THEN fs.[Currency] ELSE N'RES' END                     AS currencyaa,

    REPLICATE(N' ', 2)                                          AS country,
    REPLICATE(N' ', 2)                                          AS [counterparty_country],
    
    ISNULL(fs.[intercompany_code], REPLICATE(N' ', 5))          AS [intercompany_codea],

    CASE WHEN fs.[Maturity_Date] IS NOT NULL OR fs.[contract] = N'Card no. 8904'
         THEN N'VCT2' ELSE REPLICATE(N' ', 4) 
    END                                                         AS ITEM,

    CASE
        WHEN fs.[contract] = N'Card no. 8904' THEN N'0003' + REPLICATE(N' ',16)
        WHEN fs.[Maturity_Date] IS NULL       THEN REPLICATE(N' ',20)
        WHEN DATEDIFF(day, fs.[Date], fs.[Maturity_Date]) <= 184 THEN N'0001' + REPLICATE(N' ',16)
        WHEN DATEDIFF(day, fs.[Date], fs.[Maturity_Date]) <= 365 THEN N'0002' + REPLICATE(N' ',16)
        ELSE N'0003' + REPLICATE(N' ',16)
    END                                                         AS ITEM_CODE,

    REPLICATE(N'0', 11)                                         AS Link,
    0                                                                                       AS Amount1,
    SUM(CASE WHEN fs.[FINREP_Sector] = N'GG'        THEN fs.[Principle_Eur] ELSE 0 END)   AS Amount2,
    SUM(CASE WHEN fs.[FINREP_Sector] = N'CI'        THEN fs.[Principle_Eur] ELSE 0 END)   AS Amount3,
    0                                                                                       AS Amount4,
    0                                                                                       AS Amount5,
    0                                                                                       AS Amount6,
    0                                                                                       AS Amount7,
    SUM(CASE WHEN fs.[FINREP_Sector] = N'OFC'       THEN fs.[Principle_Eur] ELSE 0 END)   AS Amount8,
    0                                                                                       AS Amount9,
    SUM(CASE WHEN fs.[FINREP_Sector] = N'NFC' 
                    AND (fs.[Industry_Number] IS NULL 
                    OR fs.[Industry_Number] <> N'2500')
             THEN fs.[Principle_Eur] ELSE 0 END)                                          AS Amount10,
    0                                                                                       AS Amount11,
    SUM(CASE WHEN fs.[FINREP_Sector] = N'NFC' AND fs.[Industry_Number] = N'2500'
             THEN fs.[Principle_Eur] ELSE 0 END)                                          AS Amount12,
    SUM(CASE WHEN fs.[FINREP_Sector] = N'Households' THEN fs.[Principle_Eur] ELSE 0 END)  AS Amount13,
    0                                                                                       AS Amount14,
    0                                                                                       AS Amount15,
    0                                                                                       AS Amount16,
    0                                                                                       AS Amount17,
    0                                                                                       AS Amount18
INTO OUTPUTS.[yyy_90_LCR_DATA]
FROM INPUTS.[yyy_30_BBVA_Financial_Statement]            AS fs
JOIN INPUTS.[yyy_30_BBVA_Financial_Statement_Additional] AS fsa
  ON fs.[BBVA_Sequence_Distinct] = fsa.[BBVA_Sequence_Distinct]
WHERE fsa.[Liquidity_LCR_Account] IS NOT NULL
GROUP BY
    CONVERT(char(6), fs.[Date], 112),
    fsa.[Liquidity_LCR_Account],
    CASE WHEN fs.[Currency] IN (N'EUR',N'USD',N'TRY',N'MXN',N'GBP') THEN fs.[Currency] ELSE N'RES' END,
    ISNULL(fs.[intercompany_code], REPLICATE(N' ', 5)),
    CASE WHEN fs.[Maturity_Date] IS NOT NULL OR fs.[contract] = N'Card no. 8904'
         THEN N'VCT2' ELSE REPLICATE(N' ', 4) END,
    CASE
        WHEN fs.[contract] = N'Card no. 8904' THEN N'0003' + REPLICATE(N' ',16)
        WHEN fs.[Maturity_Date] IS NULL       THEN REPLICATE(N' ',20)
        WHEN DATEDIFF(day, fs.[Date], fs.[Maturity_Date]) <= 184 THEN N'0001' + REPLICATE(N' ',16)
        WHEN DATEDIFF(day, fs.[Date], fs.[Maturity_Date]) <= 365 THEN N'0002' + REPLICATE(N' ',16)
        ELSE N'0003' + REPLICATE(N' ',16)
    END;

-- Q 12: 00750_c_yyy_90_LCR_DATA_Totals 
UPDATE OUTPUTS.[yyy_90_LCR_DATA]
SET
  Amount9  = COALESCE(Amount5,0) + COALESCE(Amount6,0) + COALESCE(Amount7,0) + COALESCE(Amount8,0),
  Amount14 = COALESCE(Amount1,0) + COALESCE(Amount2,0) + COALESCE(Amount3,0) + COALESCE(Amount4,0)
           + COALESCE(Amount5,0) + COALESCE(Amount6,0) + COALESCE(Amount7,0) + COALESCE(Amount8,0)
           + COALESCE(Amount10,0) + COALESCE(Amount11,0) + COALESCE(Amount12,0) + COALESCE(Amount13,0);

-- Q 13: 00750_k01_Manual_Input_From_Jean_Paul:  It's just a Query for Visualization
SELECT 
    INPUTS.[b001_Manual_Input_From_Jean_Paul].Account,
    N'EUR' AS Currency1,
    Sum(b001_Manual_Input_From_Jean_Paul.Amount) AS SumOfAmount
--INTO MIDTABLES.[00750_k01_Manual_Input_From_Jean_Paul]
FROM INPUTS.b001_Manual_Input_From_Jean_Paul
GROUP BY INPUTS.b001_Manual_Input_From_Jean_Paul.Account;

-- Q 14: 00750_k02_Manual_Input_From_Jean_Paul --
INSERT INTO OUTPUTS.yyy_90_LCR_DATA
(
    period,
    entity_code,
    [Related_Breakdown_Number],
    Chart,
    Account,
    currencyaa,
    country,
    [counterparty_country],
    intercompany_codea,
    ITEM,
    ITEM_CODE,
    Link,
    Amount14
)
SELECT
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].period,
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].entity_code,
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].[Related_Breakdown_Number],
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].Chart,
    MIDTABLES.[00750_k01_Manual_Input_From_Jean_Paul].Account,
    MIDTABLES.[00750_k01_Manual_Input_From_Jean_Paul].Currency1,
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].country,
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].[counterparty_country],
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].intercompany_codea,
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].ITEM,
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].ITEM_CODE,
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL].Link,
    MIDTABLES.[00750_k01_Manual_Input_From_Jean_Paul].SumOfAmount
FROM
    MIDTABLES.[00750_k01_Manual_Input_From_Jean_Paul],
    INPUTS.[b001_Manual_Input_From_Jean_Paul_MODEL];


-- Q 15: 00760_a_yyy_92_LCR_DATA --
-- DELETE FROM raw.[yyy_92_LCR_DATA]


-- Q 16: 00760_b_yyy_92_LCR_DATA --
SELECT
    period,
    entity_code,
    [Related_Breakdown_Number],
    Chart,
    Account,
    currencyaa,
    country,
    [counterparty_country],
    intercompany_codea,
    ITEM,
    ITEM_CODE,
    Link,
    Amount1 as Amount1,
    Amount2 as Amount2,
    Amount3 as Amount3,
    Amount4 as Amount4,
    Amount5 as Amount5,
    Amount6 as Amount6,
    Amount7 as Amount7,
    Amount8 as Amount8,
    Amount9 as Amount9,
    Amount10 as Amount10,
    Amount11 as Amount11,
    Amount12 as Amount12,
    Amount13 as Amount13,
    Amount14 as Amount14,
    Amount15 as Amount15,
    Amount16 as Amount16,
    Amount17 as Amount17,
    Amount18 as Amount18
INTO OUTPUTS.[yyy_92_LCR_DATA]
FROM OUTPUTS.[yyy_90_LCR_DATA];

 
-- Q 17: 00760_c_yyy_92_LCR_DATA_Update_Nulls --
UPDATE OUTPUTS.yyy_92_LCR_DATA
SET
    Amount1  = ISNULL(Amount1,  0),
    Amount2  = ISNULL(Amount2,  0),
    Amount3  = ISNULL(Amount3,  0),
    Amount4  = ISNULL(Amount4,  0),
    Amount5  = ISNULL(Amount5,  0),
    Amount6  = ISNULL(Amount6,  0),
    Amount7  = ISNULL(Amount7,  0),
    Amount8  = ISNULL(Amount8,  0),
    Amount9  = ISNULL(Amount9,  0),
    Amount10 = ISNULL(Amount10, 0),
    Amount11 = ISNULL(Amount11, 0),
    Amount12 = ISNULL(Amount12, 0),
    Amount13 = ISNULL(Amount13, 0),
    Amount14 = ISNULL(Amount14, 0),
    Amount15 = ISNULL(Amount15, 0),
    Amount16 = ISNULL(Amount16, 0),
    Amount17 = ISNULL(Amount17, 0),
    Amount18 = ISNULL(Amount18, 0);  


-- Q18: 00760_d_yyy_90_LCR_DATA_Update_Is_Zero --
ALTER TABLE OUTPUTS.[yyy_92_LCR_DATA]
ADD IsZero VARCHAR(3);  

UPDATE OUTPUTS.[yyy_92_LCR_DATA]
SET IsZero = CASE
               WHEN ISNULL(Amount1,0)=0  AND ISNULL(Amount2,0)=0  AND ISNULL(Amount3,0)=0  AND
                    ISNULL(Amount4,0)=0  AND ISNULL(Amount5,0)=0  AND ISNULL(Amount6,0)=0  AND
                    ISNULL(Amount7,0)=0  AND ISNULL(Amount8,0)=0  AND ISNULL(Amount9,0)=0  AND
                    ISNULL(Amount10,0)=0 AND ISNULL(Amount11,0)=0 AND ISNULL(Amount12,0)=0 AND
                    ISNULL(Amount13,0)=0 AND ISNULL(Amount14,0)=0 AND ISNULL(Amount15,0)=0 AND
                    ISNULL(Amount16,0)=0 AND ISNULL(Amount17,0)=0 AND ISNULL(Amount18,0)=0
               THEN 'YES' ELSE 'NO'
             END;


-- Q 19: 00770_a_yyy_95_LCR_DATA_FINAL --
/* Important: This query is not called in any Macro, maybe it is executed manually
 I created the data base 00770_a_yyy_95_LCR_DATA_FINAL from this query. 
Is there always a "+" sign? */

SELECT 
    D.period,
    D.entity_code,
    D.[Related_Breakdown_Number],
    D.Chart,
    D.Account,
    D.currencyaa,
    D.country,
    D.[counterparty_country],
    D.intercompany_codea,
    D.ITEM,
    D.ITEM_CODE,
    D.Link,

    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount1))), 18)  AS [amount1],
    '+'                                                                                           AS [Sign_of_amount1],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount2))), 18)  AS [amount2],
    '+'                                                                                           AS [Sign_of_amount2],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount3))), 18)  AS [amount3],
    '+'                                                                                           AS [Sign_of_amount3],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount4))), 18)  AS [amount4],
    '+'                                                                                           AS [Sign_of_amount4],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount5))), 18)  AS [amount5],
    '+'                                                                                           AS [Sign_of_amount5],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount6))), 18)  AS [amount6],
    '+'                                                                                           AS [Sign_of_amount6],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount7))), 18)  AS [amount7],
    '+'                                                                                           AS [Sign_of_amount7],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount8))), 18)  AS [amount8],
    '+'                                                                                           AS [Sign_of_amount8],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount9))), 18)  AS [amount9],
    '+'                                                                                           AS [Sign_of_amount9],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount10))), 18) AS [amount10],
    '+'                                                                                           AS [Sign_of_amount10],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount11))), 18) AS [amount11],
    '+'                                                                                           AS [Sign_of_amount11],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount12))), 18) AS [amount12],
    '+'                                                                                           AS [Sign_of_amount12],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount13))), 18) AS [amount13],
    '+'                                                                                           AS [Sign_of_amount13],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount14))), 18) AS [amount14],
    '+'                                                                                           AS [Sign_of_amount14],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount15))), 18) AS [amount15],
    '+'                                                                                           AS [Sign_of_amount15],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount16))), 18) AS [amount16],
    '+'                                                                                           AS [Sign_of_amount16],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount17))), 18) AS [amount17],
    '+'                                                                                           AS [Sign_of_amount17],
    RIGHT(REPLICATE('0',18) + CONVERT(varchar(38), CONVERT(decimal(38,0), ABS(D.Amount18))), 18) AS [amount18],
    '+'                                                                                           AS [Sign_of_amount18],

    D.IsZero
INTO MIDTABLES.[00770_a_yyy_95_LCR_DATA_FINAL]
FROM OUTPUTS.[yyy_92_LCR_DATA] AS D
WHERE D.IsZero = 'NO';


-- Q 20: 00770_b_yyy_95_LCR_DATA_FINAL --
--DELETE FROM final.[yyy_95_LCR_DATA_FINAL];

-- Q 21: 00770_c_yyy_95_LCR_DATA_FINAL --
/* The INSERT INTO was changed for SELEC INTO, because It showed a Error */
SELECT
    S.[period],
    S.entity_code,
    S.[Related_Breakdown_Number],
    S.Chart,
    S.Account,
    S.currencyaa,
    S.country,
    S.[counterparty_country],
    S.intercompany_codea,
    S.ITEM,
    S.ITEM_CODE,
    S.Link,
    S.[amount1],
    S.[Sign_of_amount1],
    S.[amount2],
    S.[Sign_of_amount2],
    S.[amount3],
    S.[Sign_of_amount3],
    S.[amount4],
    S.[Sign_of_amount4],
    S.[amount5],
    S.[Sign_of_amount5],
    S.[amount6],
    S.[Sign_of_amount6],
    S.[amount7],
    S.[Sign_of_amount7],
    S.[amount8],
    S.[Sign_of_amount8],
    S.[amount9],
    S.[Sign_of_amount9],
    S.[amount10],
    S.[Sign_of_amount10],
    S.[amount11],
    S.[Sign_of_amount11],
    S.[amount12],
    S.[Sign_of_amount12],
    S.[amount13],
    S.[Sign_of_amount13],
    S.[amount14],
    S.[Sign_of_amount14],
    S.[amount15],
    S.[Sign_of_amount15],
    S.[amount16],
    S.[Sign_of_amount16],
    S.[amount17],
    S.[Sign_of_amount17],
    S.[amount18],
    S.[Sign_of_amount18],
    SPACE(60) AS [Breakdown_Description]
INTO [OUTPUTS].[yyy_95_LCR_DATA_FINAL]
FROM MIDTABLES.[00770_a_yyy_95_LCR_DATA_FINAL] AS S; 


-- ADD the rest of the fields: 

ALTER TABLE OUTPUTS.[yyy_95_LCR_DATA_FINAL]
ADD [concatenar] VARCHAR(714),
    [Amount19]       VARCHAR(18),[Sign_of_Amount19]     VARCHAR(1),
    [Amount20]       VARCHAR(18),[Sign_of_Amount20]     VARCHAR(1),
    [Amount21]       VARCHAR(18),[Sign_of_Amount21]     VARCHAR(1),
    [Amount22]       VARCHAR(18),[Sign_of_Amount22]     VARCHAR(1),
    [Amount23]       VARCHAR(18),[Sign_of_Amount23]     VARCHAR(1),
    [Amount24]       VARCHAR(18),[Sign_of_Amount24]     VARCHAR(1),
    [Amount25]       VARCHAR(18),[Sign_of_Amount25]     VARCHAR(1),
    [Amount26]       VARCHAR(18),[Sign_of_Amount26]     VARCHAR(1),
    [Amount27]       VARCHAR(18),[Sign_of_Amount27]     VARCHAR(1),
    [Porcentaje_1]   VARCHAR(9) ,[Sign_of_Porcentaje_1] VARCHAR(1),
    [Porcentaje_2]   VARCHAR(9) ,[Sign_of_Porcentaje_2] VARCHAR(1),
    [Porcentaje_3]   VARCHAR(9) ,[Sign_of_Porcentaje_3] VARCHAR(1),
    [Porcentaje_4]   VARCHAR(9) ,[Sign_of_Porcentaje_4] VARCHAR(1),
    [Porcentaje_5]   VARCHAR(9) ,[Sign_of_Porcentaje_5] VARCHAR(1),
    [Porcentaje_6]   VARCHAR(9) ,[Sign_of_Porcentaje_6] VARCHAR(1),
    [Porcentaje_7]   VARCHAR(9) ,[Sign_of_Porcentaje_7] VARCHAR(1),
    [length_concatenar] VARCHAR(3);



-- Q 22: 00770_d_Total_Amount_Update -- 
/* Important update*/
UPDATE OUTPUTS.[yyy_95_LCR_DATA_FINAL]
SET
    [Amount9]         = REPLICATE('0', 18),
    [Sign_of_Amount9] = '+',
    [Amount14]        = REPLICATE('0', 18),
    [Sign_of_Amount14]= '+'
WHERE
    Account LIKE '11%';      -- SERGIO


-- Q 23: 00770_e_Breakdown_Amount_Update --
UPDATE OUTPUTS.[yyy_95_LCR_DATA_FINAL]
SET
    [Amount1]          = REPLICATE('0', 18),
    [Sign_of_Amount1]  = '+',
    [Amount2]          = REPLICATE('0', 18),
    [Sign_of_Amount2]  = '+',
    [Amount3]          = REPLICATE('0', 18),
    [Sign_of_Amount3]  = '+',
    [Amount4]          = REPLICATE('0', 18),
    [Sign_of_Amount4]  = '+',
    [Amount5]          = REPLICATE('0', 18),
    [Sign_of_Amount5]  = '+',
    [Amount6]          = REPLICATE('0', 18),
    [Sign_of_Amount6]  = '+',
    [Amount7]          = REPLICATE('0', 18),
    [Sign_of_Amount7]  = '+',
    [Amount8]          = REPLICATE('0', 18),
    [Sign_of_Amount8]  = '+',
    [Amount9]          = REPLICATE('0', 18),
    [Sign_of_Amount9]  = '+',
    [Amount10]         = REPLICATE('0', 18),
    [Sign_of_Amount10] = '+',
    [Amount11]         = REPLICATE('0', 18),
    [Sign_of_Amount11] = '+',
    [Amount12]         = REPLICATE('0', 18),
    [Sign_of_Amount12] = '+',
    [Amount13]         = REPLICATE('0', 18),
    [Sign_of_Amount13] = '+'
WHERE
    Account NOT LIKE '11%';


-- Q 24: 00780_a_yyy_95_LCR_DATA_FINAL_Len_concatenar --
/*  Warning: Amounts from 19 to 27 are not created in any query. Perhaps some queries are missing. */
-- Q18: 00760_d_yyy_90_LCR_DATA_Update_Is_Zero --

UPDATE OUTPUTS.[yyy_95_LCR_DATA_FINAL]
SET   [concatenar] = CONCAT(
      [period],[entity_code],[Related_breakdown_number],[Chart],[Account],
      [currencyaa],[country],[counterparty_country],[intercompany_codea],
      [ITEM],[ITEM_CODE],[Link],
      [Amount1],[Sign_of_Amount1],
      [Amount2],[Sign_of_Amount2],
      [Amount3],[Sign_of_Amount3],
      [Amount4],[Sign_of_Amount4],
      [Amount5],[Sign_of_Amount5],
      [Amount6],[Sign_of_Amount6],
      [Amount7],[Sign_of_Amount7],
      [Amount8],[Sign_of_Amount8],
      [Amount9],[Sign_of_Amount9],
      [Amount10],[Sign_of_Amount10],
      [Amount11],[Sign_of_Amount11],
      [Amount12],[Sign_of_Amount12],
      [Amount13],[Sign_of_Amount13],
      [Amount14],[Sign_of_Amount14],
      [Amount15],[Sign_of_Amount15],
      [Amount16],[Sign_of_Amount16],
      [Amount17],[Sign_of_Amount17],
      [Amount18],[Sign_of_Amount18],
      [Amount19],[Sign_of_Amount19],
      [Amount20],[Sign_of_Amount20],
      [Amount21],[Sign_of_Amount21],
      [Amount22],[Sign_of_Amount22],
      [Amount23],[Sign_of_Amount23],
      [Amount24],[Sign_of_Amount24],
      [Amount25],[Sign_of_Amount25],
      [Amount26],[Sign_of_Amount26],
      [Amount27],[Sign_of_Amount27],
      [Porcentaje_1],[Sign_of_Porcentaje_1],
      [Porcentaje_2],[Sign_of_Porcentaje_2],
      [Porcentaje_3],[Sign_of_Porcentaje_3],
      [Porcentaje_4],[Sign_of_Porcentaje_4],
      [Porcentaje_5],[Sign_of_Porcentaje_5],
      [Porcentaje_6],[Sign_of_Porcentaje_6],
      [Porcentaje_7],[Sign_of_Porcentaje_7],
      [Breakdown_Description]);

UPDATE OUTPUTS.[yyy_95_LCR_DATA_FINAL]
SET length_concatenar = LEN(concatenar);



-- Q 25: 9999_ROW_SIRASI_ICIN --
/* ! DataBase required for Visual Basic Module:  C_Breakdown_No()
 Fist, 9999_ROW_SIRASI_ICIN is not used in Macro_1, so I create the database based in the Access File's query: */
SELECT
    F.period,
    F.entity_code,
    F.[Related_breakdown_number],
    F.Chart,
    F.Account,
    F.currencyaa,
    F.country,
    F.[counterparty_country],
    F.intercompany_codea,
    F.ITEM,
    F.ITEM_CODE,
    F.Link,
    F.[Amount1],  F.[Sign_of_Amount1],
    F.[Amount2],  F.[Sign_of_Amount2],
    F.[Amount3],  F.[Sign_of_Amount3],
    F.[Amount4],  F.[Sign_of_Amount4],
    F.[Amount5],  F.[Sign_of_Amount5],
    F.[Amount6],  F.[Sign_of_Amount6],
    F.[Amount7],  F.[Sign_of_Amount7],
    F.[Amount8],  F.[Sign_of_Amount8],
    F.[Amount9],  F.[Sign_of_Amount9],
    F.[Amount10], F.[Sign_of_Amount10],
    F.[Amount11], F.[Sign_of_Amount11],
    F.[Amount12], F.[Sign_of_Amount12],
    F.[Amount13], F.[Sign_of_Amount13],
    F.[Amount14], F.[Sign_of_Amount14],
    F.[Amount15], F.[Sign_of_Amount15],
    F.[Amount16], F.[Sign_of_Amount16],
    F.[Amount17], F.[Sign_of_Amount17],
    F.[Amount18], F.[Sign_of_Amount18],
    F.[Amount19], F.[Sign_of_Amount19],
    F.[Amount20], F.[Sign_of_Amount20],
    F.[Amount21], F.[Sign_of_Amount21],
    F.[Amount22], F.[Sign_of_Amount22],
    F.[Amount23], F.[Sign_of_Amount23],
    F.[Amount24], F.[Sign_of_Amount24],
    F.[Amount25], F.[Sign_of_Amount25],
    F.[Amount26], F.[Sign_of_Amount26],
    F.[Amount27], F.[Sign_of_Amount27],
    F.[Porcentaje_1], F.[Sign_of_Porcentaje_1],
    F.[Porcentaje_2], F.[Sign_of_Porcentaje_2],
    F.[Porcentaje_3], F.[Sign_of_Porcentaje_3],
    F.[Porcentaje_4], F.[Sign_of_Porcentaje_4],
    F.[Porcentaje_5], F.[Sign_of_Porcentaje_5],
    F.[Porcentaje_6], F.[Sign_of_Porcentaje_6],
    F.[Porcentaje_7], F.[Sign_of_Porcentaje_7],
    F.[Breakdown_Description],
    F.concatenar,
    F.length_concatenar
FROM OUTPUTS.[yyy_95_LCR_DATA_FINAL] AS F
ORDER BY
    F.period,
    F.entity_code,
    F.[Related_breakdown_number],
    F.Chart,
    F.Account,
    F.currencyaa,
    F.country,
    F.[counterparty_country],
    F.intercompany_codea,
    F.ITEM,
    F.ITEM_CODE,
    F.Link;

