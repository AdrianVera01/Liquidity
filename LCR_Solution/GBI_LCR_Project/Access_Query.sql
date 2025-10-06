USE GBI_LIQUIDITY
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

