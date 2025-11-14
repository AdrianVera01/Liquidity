-- code to try to create validation checks for LCR accounts --

-- Q1: creat rules table -- 

CREATE TABLE dbo.LCR_ValidationRule (
  RuleId         int IDENTITY(1,1) PRIMARY KEY,
  Account        int      NOT NULL,
  AmountNo       int      NOT NULL,          -- 1..27
  ExpectedCode   tinyint  NOT NULL,          -- 0..4
  CONSTRAINT UQ_LCR_Rule UNIQUE (Account, AmountNo)  -- combination of these columns must be unique across all rows in this table
);

/*
Codes:
0 = must NOT be reported -> amount = 18 zeros
1 = optional any sign (unless MustBeReported=1)
2 = auto-calculated -> must NOT be reported (18 zeros)
3 = must be NEGATIVE  (non-zero AND Sign='-')
4 = must be POSITIVE  (non-zero AND Sign='+')
*/

-- EXAMPLE: rule for LCR account 15400 -- 
-- Amounts 1..13: should not be reported (18 zeros)
  -- inserts 13 rows into the LCR_ValidationRule table, one for each amount number from 1 to 13

INSERT dbo.LCR_ValidationRule (Account, AmountNo, ExpectedCode)
SELECT 15400, v.n, 0
FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13)) v(n);

-- Amount 14: must be positive if reported

INSERT dbo.LCR_ValidationRule (Account, AmountNo, ExpectedCode)
VALUES (15400, 14, 4);

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
    (1,  amount1,  sign_of_amount1),
    (2,  amount2,  sign_of_amount2),
    (3,  amount3,  sign_of_amount3),
    (4,  amount4,  sign_of_amount4),
    (5,  amount5,  sign_of_amount5),
    (6,  amount6,  sign_of_amount6),
    (7,  amount7,  sign_of_amount7),
    (8,  amount8,  sign_of_amount8),
    (9,  amount9,  sign_of_amount9),
    (10, amount10, sign_of_amount10),
    (11, amount11, sign_of_amount11),
    (12, amount12, sign_of_amount12),
    (13, amount13, sign_of_amount13),
    (14, amount14, sign_of_amount14),
    (15, amount15, sign_of_amount15),
    (16, amount16, sign_of_amount16),
    (17, amount17, sign_of_amount17),
    (18, amount18, sign_of_amount18),
    (19, amount19, sign_of_amount19),
    (20, amount20, sign_of_amount20),
    (21, amount21, sign_of_amount21),
    (22, amount22, sign_of_amount22),
    (23, amount23, sign_of_amount23),
    (24, amount24, sign_of_amount24),
    (25, amount25, sign_of_amount25),
    (26, amount26, sign_of_amount26),
    (27, amount27, sign_of_amount27)
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
  JOIN dbo.[LCR_ValidationRule] r
    ON r.Account  = n.Account
   AND r.AmountNo = n.AmountNo
)
SELECT period, entity_code, Account, AmountNo,
       ExpectedCode, AmountRaw, [Sign]=SignRaw,
       IsCompliant, ViolationReason
FROM eval
WHERE IsCompliant = 0
ORDER BY period, entity_code, Account, AmountNo;    -- final output returns violations and the reason for them

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




