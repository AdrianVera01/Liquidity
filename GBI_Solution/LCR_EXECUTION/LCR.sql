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
    M.[Any_Match],
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

--Q 10: 00750_a_yyy_90_LCR_DATA--
-- It is uploaded for the structure. Changing the next query  00750_a_yyy_90_LCR_DATA wont be required as an Input 
-- DELETE FROM raw.[yyy_90_LCR_DATA]

-- Q 11: 00750_b_yyy_90_LCR_DATA: First version of Final LCR-- 
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
FROM INPUTS.b001_Manual_Input_From_Jean_Paul
GROUP BY INPUTS.b001_Manual_Input_From_Jean_Paul.Account;


-- Q 13: 00750_k01_Manual_Input_From_Jean_Paul:  It's just a Query for Visualization

SELECT 
    INPUTS.[b001_Manual_Input_From_Jean_Paul].Account,
    N'EUR' AS Currency1,
    Sum(b001_Manual_Input_From_Jean_Paul.Amount) AS SumOfAmount
INTO MIDTABLES.[00750_k01_Manual_Input_From_Jean_Paul]
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

