USE GBI_LCR_LIQUIDITY


-- A01_Primary --

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



-- C_Breakdown_No() --

WITH c AS 
(
    SELECT
        *,
        rn = ROW_NUMBER() OVER (ORDER BY (SELECT 1))
    FROM dbo.[9999_ROW_SIRASI_ICIN]
)
UPDATE 
SET [Related_breakdown_number] = RIGHT('000000' + CAST(rn AS varchar(6)), 6);

