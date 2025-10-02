USE GBI_LIQUIDITY


-- 00100_a_Overwrite_Keys -- 
UPDATE raw.yyy_30_BBVA_Financial_Statement_Additional SET raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account = NULL
WHERE (((raw.yyy_30_BBVA_Financial_Statement_Additional.Liquidity_LCR_Account) IS NOT NULL));

-- 00110_a_Update_Lookup_First_Mapping --
UPDATE raw.a000_LCR_Account_Mapping 
SET raw.a000_LCR_Account_Mapping.KeyA = (CASE WHEN [Group_2] Is Null THEN '*' ELSE [Group_2] END) + '_' + (CASE WHEN [Is_Product_Number_21095_21096] Is Null THEN '*' ELSE [Is_Product_Number_21095_21096] END) + '_' + (CASE WHEN [Product_Number] Is Null THEN '*' ELSE [Product_Number] END) + '_' + (CASE WHEN [Is_Product_Number_23000_23004] Is Null THEN '*' ELSE [Is_Product_Number_23000_23004] END) + '_' + (CASE WHEN [contract] Is Null THEN '*' ELSE [contract] END), raw.a000_LCR_Account_Mapping.Sorgu_Final = Null, raw.a000_LCR_Account_Mapping.Any_Match = Null;
