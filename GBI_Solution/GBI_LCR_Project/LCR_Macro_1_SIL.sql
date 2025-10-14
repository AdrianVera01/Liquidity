USE GBI_LCR_LIQUIDITY

-- 00200_a_Mother_Data_First_Mapping --
DELETE FROM raw.[yy_10_a_Mother_Data_First_Mapping];

-- 00210_a_Distinct_Mother_Data_First_Mapping --
DELETE FROM raw.[yy_10_b_Distinct_Mother_Data_First_Mapping];

-- 00750_a_yyy_90_LCR_DATA -- 
DELETE FROM raw.[yyy_90_LCR_DATA];

--  00760_a_yyy_92_LCR_DATA --
DELETE FROM raw.[yyy_92_LCR_DATA];

-- 00770_b_yyy_95_LCR_DATA_FINAL --
DELETE FROM raw.[yyy_95_LCR_DATA_FINAL];
