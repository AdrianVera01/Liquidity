USE GBI_LCR_LIQUIDITY

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
    M.[Any_Match],
    M.[Sorgu_Final]
FROM raw.[a000_LCR_Account_Mapping] AS M
ORDER BY
    M.[Sequence];

--Q 02: 00100_a_Overwrite_Keys -- 
UPDATE raw.yyy_30_BBVA_Financial_Statement_Additional SET raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account = NULL
WHERE (((raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account) IS NOT NULL));

-- Q 03:  00110_a_Update_Lookup_First_Mapping --
UPDATE raw.a000_LCR_Account_Mapping 
SET raw.a000_LCR_Account_Mapping.KeyA = (CASE WHEN [Group_2] Is Null THEN '*' ELSE [Group_2] END) + '_' + (CASE WHEN [Is_Product_Number_21095_21096] Is Null THEN '*' ELSE [Is_Product_Number_21095_21096] END) + '_' + (CASE WHEN [Product_Number] Is Null THEN '*' ELSE [Product_Number] END) + '_' + (CASE WHEN [Is_Product_Number_23000_23004] Is Null THEN '*' ELSE [Is_Product_Number_23000_23004] END) + '_' + (CASE WHEN [contract] Is Null THEN '*' ELSE [contract] END), raw.a000_LCR_Account_Mapping.Sorgu_Final = Null, raw.a000_LCR_Account_Mapping.Any_Match = Null;

-- Q 04: 00200_a_Mother_Data_First_Mapping_SQLServer
DELETE FROM raw.[yy_10_a_Mother_Data_First_Mapping];

-- 00200_c_Mother_Data_First_Mapping
INSERT INTO raw.[yy_10_a_Mother_Data_First_Mapping] 
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
FROM raw.[00200_b_Mother_Data_First_Mapping] AS b;


-- 00210_a_Distinct_Mother_Data_First_Mapping --
DELETE FROM raw.[yy_10_b_Distinct_Mother_Data_First_Mapping];

-- 00210_b_Distinct_Mother_Data_First_Mapping -- It's just a Query for Visualization

SELECT
    fs.[BBVA_Sequence_Distinct]                                   AS [BBVA_Sequence_Distinct],
    fs.[group2]                                                   AS [Group2_B],
    CASE WHEN fs.[Product_Number] IN ('21095','21096')
         THEN N'Yes' ELSE N'No' END                               AS [Is_Product_Number_21095_21096_B],
    fs.[Product_Number]                                           AS [Product_Number_B],
    CASE WHEN fs.[Product_Number] IN ('23000','23004')
         THEN N'Yes' ELSE N'No' END                               AS [Is_Product_Number_23000_23004_B],
    fs.[Contract]                                                 AS [Contract_B]
FROM raw.[yyy_30_BBVA_Financial_Statement] AS fs;


-- A01_Primary : This is one of the functions in VBS --

UPDATE DMD
    SET DMD.Summary_KeyC = LAM.KeyA,
        DMD.LCR_account_C = LAM.LCR_account
    FROM raw.[yy_10_b_Distinct_Mother_Data_First_Mapping] DMD
    INNER JOIN raw.[0_a000_LCR_account_Mapping] LAM
        ON DMD.KeyC LIKE LAM.KeyA
    WHERE DMD.Summary_KeyC IS NULL;
  
UPDATE LAM
SET LAM.Any_Match = 'Yes'
FROM raw.[0_a000_LCR_account_Mapping] LAM
WHERE EXISTS (
    SELECT 1 
    FROM raw.[yy_10_b_Distinct_Mother_Data_First_Mapping] DMD
    WHERE DMD.KeyC LIKE LAM.KeyA 
    AND DMD.Summary_KeyC IS NULL
);


-- 00210_c_First_Mapping_DATA_UPDATE --
UPDATE FSA
SET FSA.[Liquidity_LCR_Account] = DMDFM.[LCR_account_C]
FROM raw.[yyy_30_BBVA_Financial_Statement_Additional] AS FSA
INNER JOIN raw.[yyy_30_BBVA_Financial_Statement]            AS FS
  ON FSA.[BBVA_Sequence_Distinct] = fs.[BBVA_Sequence_Distinct]
INNER JOIN raw.[yy_10_a_Mother_Data_First_Mapping]          AS MDFM
  ON FS.[BBVA_Sequence_Distinct] = MDFM.[DATA_SequenceB]
INNER JOIN raw.[yy_10_b_Distinct_Mother_Data_First_Mapping] AS DMDFM
  ON MDFM.[Keyb] = DMDFM.[KeyC]
WHERE DMDFM.[LCR_account_C] IS NOT NULL;

--00750_a_yyy_90_LCR_DATA-- 
DELETE FROM raw.[yyy_90_LCR_DATA]

-- 00750_b_yyy_90_LCR_DATA: First version of Final LCR-- 
INSERT INTO raw.[yyy_90_LCR_DATA] 
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
    Amount1,
    Amount2,
    Amount3,
    Amount4,
    Amount5,
    Amount6,
    Amount7,
    Amount8,
    Amount9,
    Amount10,
    Amount11,
    Amount12,
    Amount13,
    Amount14,
    Amount15,
    Amount16,
    Amount17,
    Amount18
)
SELECT
    CONVERT(char(6), fs.[Date], 112)                            AS period,                     -- YYYYMM
    70501                                                       AS entity_code,
    N'000001'                                                   AS [Related_Breakdown_Number],
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
FROM raw.[yyy_30_BBVA_Financial_Statement]            AS fs
JOIN raw.[yyy_30_BBVA_Financial_Statement_Additional] AS fsa
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

-- 00750_c_yyy_90_LCR_DATA_Totals 
UPDATE raw.[yyy_90_LCR_DATA]
SET
  Amount9  = COALESCE(Amount5,0) + COALESCE(Amount6,0) + COALESCE(Amount7,0) + COALESCE(Amount8,0),
  Amount14 = COALESCE(Amount1,0) + COALESCE(Amount2,0) + COALESCE(Amount3,0) + COALESCE(Amount4,0)
           + COALESCE(Amount5,0) + COALESCE(Amount6,0) + COALESCE(Amount7,0) + COALESCE(Amount8,0)
           + COALESCE(Amount10,0) + COALESCE(Amount11,0) + COALESCE(Amount12,0) + COALESCE(Amount13,0);

-- 00750_k01_Manual_Input_From_Jean_Paul:  It's just a Query for Visualization
SELECT 
    [b001_Manual_Input_From_Jean_Paul].Account,
    N'EUR' AS Currency1,
    Sum(b001_Manual_Input_From_Jean_Paul.Amount) AS SumOfAmount
FROM raw.b001_Manual_Input_From_Jean_Paul
GROUP BY raw.b001_Manual_Input_From_Jean_Paul.Account;



-- 00750_k02_Manual_Input_From_Jean_Paul --
INSERT INTO raw.yyy_90_LCR_DATA
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
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].period,
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].entity_code,
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].[Related_Breakdown_Number],
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].Chart,
    raw.[00750_k01_Manual_Input_From_Jean_Paul].Account,
    raw.[00750_k01_Manual_Input_From_Jean_Paul].Currency1,
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].country,
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].[counterparty_country],
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].intercompany_codea,
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].ITEM,
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].ITEM_CODE,
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL].Link,
    raw.[00750_k01_Manual_Input_From_Jean_Paul].SumOfAmount
FROM
    raw.[00750_k01_Manual_Input_From_Jean_Paul],
    raw.[b001_Manual_Input_From_Jean_Paul_MODEL];


    -- 00760_a_yyy_92_LCR_DATA --
DELETE FROM raw.[yyy_92_LCR_DATA]


-- 00760_b_yyy_92_LCR_DATA --
INSERT INTO raw.[yyy_92_LCR_DATA] (
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
    Amount1,
    Amount2,
    Amount3,
    Amount4,
    Amount5,
    Amount6,
    Amount7,
    Amount8,
    Amount9,
    Amount10,
    Amount11,
    Amount12,
    Amount13,
    Amount14,
    Amount15,
    Amount16,
    Amount17,
    Amount18
)
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
    Amount1 as Amount1a,   -- aliases like "AS Amount1a" aren't needed for INSERT
    Amount2,
    Amount3,
    Amount4,
    Amount5,
    Amount6,
    Amount7,
    Amount8,
    Amount9,
    Amount10,
    Amount11,
    Amount12,
    Amount13,
    Amount14,
    Amount15,
    Amount16,
    Amount17,
    Amount18
FROM raw.[yyy_90_LCR_DATA];


--  00760_c_yyy_92_LCR_DATA_Update_Nulls --
UPDATE raw.yyy_92_LCR_DATA
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

--  00760_d_yyy_90_LCR_DATA_Update_Is_Zero --
UPDATE raw.[yyy_92_LCR_DATA]
SET IsZero = CASE
               WHEN ISNULL(Amount1,0)=0  AND ISNULL(Amount2,0)=0  AND ISNULL(Amount3,0)=0  AND
                    ISNULL(Amount4,0)=0  AND ISNULL(Amount5,0)=0  AND ISNULL(Amount6,0)=0  AND
                    ISNULL(Amount7,0)=0  AND ISNULL(Amount8,0)=0  AND ISNULL(Amount9,0)=0  AND
                    ISNULL(Amount10,0)=0 AND ISNULL(Amount11,0)=0 AND ISNULL(Amount12,0)=0 AND
                    ISNULL(Amount13,0)=0 AND ISNULL(Amount14,0)=0 AND ISNULL(Amount15,0)=0 AND
                    ISNULL(Amount16,0)=0 AND ISNULL(Amount17,0)=0 AND ISNULL(Amount18,0)=0
               THEN 'YES' ELSE 'NO'
             END;
-- 00770_a_yyy_95_LCR_DATA_FINAL --
/* Important: This query is not called in any Macro, maybe it is executed manually
 I created the data base 00770_a_yyy_95_LCR_DATA_FINAL from this query. */
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
INTO raw.[00770_a_yyy_95_LCR_DATA_FINAL]
FROM raw.[yyy_92_LCR_DATA] AS D
WHERE D.IsZero = 'NO';


-- 00770_b_yyy_95_LCR_DATA_FINAL --
DELETE FROM final.[yyy_95_LCR_DATA_FINAL];

-- 00770_c_yyy_95_LCR_DATA_FINAL --
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
    SPACE(60) AS [Breakdown Description]
INTO [final].[yyy_95_LCR_DATA_FINAL]
FROM raw.[00770_a_yyy_95_LCR_DATA_FINAL] AS S;

-- 00770_d_Total_Amount_Update -- 
/* Important update*/
UPDATE final.[yyy_95_LCR_DATA_FINAL]
SET
    [Amount9]         = REPLICATE('0', 18),
    [Sign_of_Amount9] = '+',
    [Amount14]        = REPLICATE('0', 18),
    [Sign_of_Amount14]= '+'
WHERE
    Account LIKE '11%';


-- 00770_e_Breakdown_Amount_Update --
UPDATE final.[yyy_95_LCR_DATA_FINAL]
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


-- 00780_a_yyy_95_LCR_DATA_FINAL_Len_concatenar --
/*  Warning: Amounts from 19 to 27 are not created in any query. Perhaps some queries are missing. */
UPDATE final.[yyy_95_LCR_DATA_FINAL]
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
      [Porcentaje 1],[Sign_of_Porcentaje 1],
      [Porcentaje 2],[Sign_of_Porcentaje 2],
      [Porcentaje 3],[Sign_of_Porcentaje 3],
      [Porcentaje 4],[Sign_of_Porcentaje 4],
      [Porcentaje 5],[Sign_of_Porcentaje 5],
      [Porcentaje 6],[Sign_of_Porcentaje 6],
      [Porcentaje 7],[Sign_of_Porcentaje 7],
      [Breakdown Description]);

UPDATE final.[yyy_95_LCR_DATA_FINAL]
SET length_concatenar = LEN(concatenar);


-- !Visual Basic Module:  C_Breakdown_No() --

/* Fist, 9999_ROW_SIRASI_ICIN is not used in Macro_1, so I create the database based in the Access File's query: */
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
    F.[Porcentaje1], F.[Sign_of_Porcentaje1],
    F.[Porcentaje2], F.[Sign_of_Porcentaje2],
    F.[Porcentaje3], F.[Sign_of_Porcentaje3],
    F.[Porcentaje4], F.[Sign_of_Porcentaje4],
    F.[Porcentaje5], F.[Sign_of_Porcentaje5],
    F.[Porcentaje6], F.[Sign_of_Porcentaje6],
    F.[Porcentaje7], F.[Sign_of_Porcentaje7],
    F.[Breakdown_Description],
    F.concatenar,
    F.length_concatenar
FROM final.[yyy_95_LCR_DATA_FINAL] AS F
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


/* After having the table 9999_ROW_SIRASI_ICIN, The Module C_Breakdown_No() can be executed.*/

WITH c AS 
(
    SELECT
        *,
        rn = ROW_NUMBER() OVER (ORDER BY (SELECT 1))
    FROM dbo.[9999_ROW_SIRASI_ICIN]
)
UPDATE 
SET [Related_breakdown_number] = RIGHT('000000' + CAST(rn AS varchar(6)), 6);

