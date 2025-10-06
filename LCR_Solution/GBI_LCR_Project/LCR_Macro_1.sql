USE GBI_LIQUIDITY


-- 00100_a_Overwrite_Keys -- 
UPDATE raw.yyy_30_BBVA_Financial_Statement_Additional SET raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account = NULL
WHERE (((raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account) IS NOT NULL));

-- 00110_a_Update_Lookup_First_Mapping --
UPDATE raw.a000_LCR_Account_Mapping 
SET raw.a000_LCR_Account_Mapping.KeyA = (CASE WHEN [Group_2] Is Null THEN '*' ELSE [Group_2] END) + '_' + (CASE WHEN [Is_Product_Number_21095_21096] Is Null THEN '*' ELSE [Is_Product_Number_21095_21096] END) + '_' + (CASE WHEN [Product_Number] Is Null THEN '*' ELSE [Product_Number] END) + '_' + (CASE WHEN [Is_Product_Number_23000_23004] Is Null THEN '*' ELSE [Is_Product_Number_23000_23004] END) + '_' + (CASE WHEN [contract] Is Null THEN '*' ELSE [contract] END), raw.a000_LCR_Account_Mapping.Sorgu_Final = Null, raw.a000_LCR_Account_Mapping.Any_Match = Null;

--00200_a_Mother_Data_First_Mapping_SQLServer
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
