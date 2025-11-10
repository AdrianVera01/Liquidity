USE GBI_INFLOWS_EXECUTION

-- Q01 : 0_a000_Inflow_Accounts_Mapping

SELECT 
[INPUTS].a000_Inflow_Accounts_Mapping.Sequence,
[INPUTS].a000_Inflow_Accounts_Mapping.Inflow_Account,
[INPUTS].a000_Inflow_Accounts_Mapping.Group2,
[INPUTS].a000_Inflow_Accounts_Mapping.[Is_Group2_Loans_and_advances],
[INPUTS].a000_Inflow_Accounts_Mapping.[Finrep_Sector],
[INPUTS].a000_Inflow_Accounts_Mapping.Is_Collat_Type_101_102,
[INPUTS].a000_Inflow_Accounts_Mapping.IFRS_P_S,
[INPUTS].a000_Inflow_Accounts_Mapping.[Product_Number],
[INPUTS].a000_Inflow_Accounts_Mapping.[Is_Product_Number_21076],
[INPUTS].a000_Inflow_Accounts_Mapping.KeyA,
[INPUTS].a000_Inflow_Accounts_Mapping.Any_Match,
[INPUTS].a000_Inflow_Accounts_Mapping.Sorgu_Final,
[INPUTS].a000_Inflow_Accounts_Mapping.Balance
INTO [MIDTABLES].[0_a000_Inflow_Accounts_Mapping]
FROM [INPUTS].a000_Inflow_Accounts_Mapping
ORDER BY [INPUTS].a000_Inflow_Accounts_Mapping.Sequence;
