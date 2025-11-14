-- code to try to create validation checks for LCR accounts --
USE GBI_LCR_EXECUTION



-- Q1: creat rules table -- 

CREATE TABLE [VAL].[LCR_ValidationRule] (
  RuleId         int IDENTITY(1,1) PRIMARY KEY,
  Account        int      NOT NULL,
  AmountNo       int      NOT NULL,          -- 1..27
  ExpectedCode   tinyint  NOT NULL,          -- 0..4
  CONSTRAINT UQ_LCR_Rule UNIQUE (Account, AmountNo)  -- combination of these columns must be unique across all rows in this table
);
DELETE FROM [VAL].[LCR_ValidationRule]
/*
Codes:
0 = must NOT be reported -> amount = 18 zeros
1 = optional any sign (unless MustBeReported=1)
2 = auto-calculated -> must NOT be reported (18 zeros)
3 = must be NEGATIVE  (non-zero AND Sign='-')
4 = must be POSITIVE  (non-zero AND Sign='+')
*/


-- JOIN bt CARCASA AND LCR FINAL 

/* Desglose_Pais_Contraparte and Intercompany have the same value for LRC Carcasa
That's why are excluded, but we should see if the other reports have the same value */


INSERT INTO [VAL].[LCR_ValidationRule] (Account, AmountNo, ExpectedCode)
SELECT
    D.[Cuenta]                                                          AS Account,
    TRY_CAST(
        SUBSTRING(
            D.[Importe],
            PATINDEX('%[0-9]%', D.[Importe]),
            LEN(D.[Importe]) - PATINDEX('%[0-9]%', D.[Importe]) + 1
        ) AS INT
    )                                                                   AS AmountNo,
    D.[Valor_del_importe]                                               AS ExpectedCode
FROM (
    SELECT DISTINCT
        C.[Cuenta],
        C.[Importe],
        C.[Minimo_Nivel],
        C.[Valor_del_importe],
        C.[Bucket_del_Importe]
    FROM [OUTPUTS].[yyy_95_LCR_DATA_FINAL] F
    INNER JOIN [VAL].[LCR_Carcasa] C
        ON F.[Account] = C.[Cuenta]
) D;

-- Q2: VALIDATOR

DECLARE @Zero18 char(18) = REPLICATE('0',18); -- the exact 18-zero string that means an amount is not reported

;WITH src AS (
  SELECT *
  FROM OUTPUTS.[yyy_95_LCR_DATA_FINAL]     -- the final outputs table
),
u AS (  -- unpivot 27 pairs
  SELECT
    s.period, s.entity_code, s.Account,
    v.AmountNo,
    v.AmountRaw,   -- 18-char fixed string
    v.SignRaw      -- '+' or '-'
  FROM src s
  CROSS APPLY (VALUES
    (1,  Amount1,  Sign_of_Amount_1),
    (2,  Amount2,  Sign_of_Amount_2),
    (3,  Amount3,  Sign_of_Amount_3),
    (4,  Amount4,  Sign_of_Amount_4),
    (5,  Amount5,  Sign_of_Amount_5),
    (6,  Amount6,  Sign_of_Amount_6),
    (7,  Amount7,  Sign_of_Amount_7),
    (8,  Amount8,  Sign_of_Amount_8),
    (9,  Amount9,  Sign_of_Amount_9),
    (10, Amount10, Sign_of_Amount_10),
    (11, Amount11, Sign_of_Amount_11),
    (12, Amount12, Sign_of_Amount_12),
    (13, Amount13, Sign_of_Amount_13),
    (14, Amount14, Sign_of_Amount_14)
  ) v(AmountNo, AmountRaw, SignRaw) -- 'unpivoting' the original table so that each row now says: “for this period/entity/account, Amount 14 has value '000…021' and sign '+'”, etc.
),
norm AS (  -- zero vs non-zero flag
  SELECT
    u.*,
    CASE WHEN u.AmountRaw = @Zero18 THEN 0 ELSE 1 END AS IsNonZero   -- 1 => “reported”
  FROM u
),
eval AS (
  SELECT
    n.period, n.entity_code, n.Account, n.AmountNo,
    r.ExpectedCode, n.AmountRaw, n.SignRaw, n.IsNonZero,

    -- pass/fail flag
    CASE
      WHEN r.ExpectedCode IN (0,2) THEN CASE WHEN n.AmountRaw = @Zero18                  THEN 1 ELSE 0 END
      WHEN r.ExpectedCode = 1      THEN 1  -- anything allowed (zero or non-zero, any sign)
      WHEN r.ExpectedCode = 3      THEN CASE WHEN n.IsNonZero=0 OR n.SignRaw='-'         THEN 1 ELSE 0 END
      WHEN r.ExpectedCode = 4      THEN CASE WHEN n.IsNonZero=0 OR n.SignRaw='+'         THEN 1 ELSE 0 END
      ELSE 0
    END AS IsCompliant,

    CASE
      WHEN r.ExpectedCode IN (0,2) AND n.IsNonZero=1
           THEN 'Should NOT be reported: must be 18 zeros.'
      WHEN r.ExpectedCode = 3 AND (n.IsNonZero=1 AND n.SignRaw <> '-')
           THEN 'If reported, must be negative (<0).'
      WHEN r.ExpectedCode = 4 AND (n.IsNonZero=1 AND n.SignRaw <> '+')
           THEN 'If reported, must be positive (>0).'
      ELSE NULL
    END AS ViolationReason
  FROM norm n
  JOIN [VAL].[LCR_ValidationRule] r
    ON r.Account  = n.Account
   AND r.AmountNo = n.AmountNo
)
SELECT period, entity_code, Account, AmountNo,
       ExpectedCode, AmountRaw, [Sign]=SignRaw,
       IsCompliant, ViolationReason
FROM eval
WHERE IsCompliant = 0
ORDER BY period, entity_code, Account, AmountNo;    -- final output returns violations and the reason for them




/*
-- test (NB revert after):
UPDATE OUTPUTS.yyy_95_LCR_DATA_FINAL
SET amount9 = '000000000000000020' , sign_of_amount9 = '+'
WHERE Account = 15400
  AND entity_code = 70501;

-- re run the VALIDATOR

-- revert of test
UPDATE OUTPUTS.yyy_95_LCR_DATA_FINAL
SET amount9 = '000000000000000000'
WHERE Account = 15400
  AND entity_code = 70501;

*/


