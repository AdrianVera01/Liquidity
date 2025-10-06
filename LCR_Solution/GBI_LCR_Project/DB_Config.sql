USE GBI_LIQUIDITY

CREATE SCHEMA raw
CREATE SCHEMA work
CREATE SCHEMA final

ALTER TABLE raw.a000_LCR_Account_Mapping 
ALTER COLUMN KeyA VARCHAR(50) NULL;

ALTER TABLE raw.a000_LCR_Account_Mapping 
ALTER COLUMN LCR_Account VARCHAR(50) NULL;

ALTER TABLE raw.a000_LCR_Account_Mapping 
ALTER COLUMN Product_Number VARCHAR(50) NULL;

ALTER TABLE raw.a000_LCR_Account_Mapping 
ALTER COLUMN Sorgu_Final NVARCHAR(250) NULL;

ALTER TABLE raw.a000_LCR_Account_Mapping 
ALTER COLUMN Any_Match NVARCHAR(250) NULL;


-- Update datatype [yy_10_a_Mother_Data_First_Mapping] -- 
ALTER TABLE raw.[yy_10_a_Mother_Data_First_Mapping]
ALTER COLUMN DATA_SequenceB VARCHAR(50) NULL;

ALTER TABLE raw.[yy_10_a_Mother_Data_First_Mapping]
ALTER COLUMN Keyb VARCHAR(50) NULL;

ALTER TABLE raw.[yy_10_a_Mother_Data_First_Mapping]
ALTER COLUMN Group2_B VARCHAR(50) NULL;

ALTER TABLE raw.[yy_10_a_Mother_Data_First_Mapping]
ALTER COLUMN [Is_Product_Number_21095_21096_B] VARCHAR(50) NULL;

ALTER TABLE raw.[yy_10_a_Mother_Data_First_Mapping]
ALTER COLUMN [Product_Number_B] VARCHAR(50) NULL;

ALTER TABLE raw.[yy_10_a_Mother_Data_First_Mapping]
ALTER COLUMN [Is_Product_Number_23000_23004_B] VARCHAR(50) NULL;

ALTER TABLE raw.[yy_10_a_Mother_Data_First_Mapping]
ALTER COLUMN Contract_B VARCHAR(50) NULL;


--
ALTER TABLE raw.[yy_10_a_Mother_Data_First_Mapping]
ALTER COLUMN Contract_B VARCHAR(50) NULL;



ALTER TABLE raw.[0_a000_LCR_account_Mapping]
ALTER COLUMN [Any_Match] VARCHAR(50) NULL;


ALTER TABLE raw.[yy_10_b_Distinct_Mother_Data_First_Mapping]
ALTER COLUMN [Any_Match] VARCHAR(50) NULL;



ALTER TABLE [GBI_LIQUIDITY].[raw].[yyy_30_BBVA_Financial_Statement]
ALTER COLUMN [Date] INT;

UPDATE [GBI_LIQUIDITY].[raw].[yyy_30_BBVA_Financial_Statement]
SET [Date] = 202209

UPDATE [GBI_LIQUIDITY].[raw].[yyy_30_BBVA_Financial_Statement]
SET [Date] = YEAR([Date])*100 + MONTH([Date]);


-- Rename fields with spaces ---
EXEC sp_rename 'raw.[yyy_30_BBVA_Financial_Statement].[Principle (Eur)]', '[Principle_(Eur)]', 'COLUMN';
