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
--INTO [MIDTABLES].[0_a000_Inflow_Accounts_Mapping]
FROM [INPUTS].a000_Inflow_Accounts_Mapping
ORDER BY [INPUTS].a000_Inflow_Accounts_Mapping.Sequence;


-- Q02 : 00100_a_Overwrite_Keys

UPDATE [INPUTS].[yyy_30_BBVA_Financial_Statement_Additional]
SET Liquidity_inflow_Account = NULL
WHERE Liquidity_inflow_Account IS NOT NULL;

-- Q03 : 00110_a_Update_Lookup_First_Mapping

UPDATE [INPUTS].[a000_Inflow_Accounts_Mapping]
SET
    KeyA = CONCAT(
        CASE WHEN Group2 IS NULL THEN '*' ELSE Group2 END, '_',
        CASE WHEN Is_Group2_Loans_and_advances IS NULL THEN '*' ELSE Is_Group2_Loans_and_advances END, '_',
        CASE WHEN Finrep_Sector IS NULL THEN '*' ELSE Finrep_Sector END, '_',
        CASE WHEN Is_Collat_Type_101_102 IS NULL THEN '*' ELSE Is_Collat_Type_101_102 END, '_',
        CASE WHEN IFRS_P_S IS NULL THEN '*' ELSE IFRS_P_S END, '_',
        CASE WHEN Product_Number IS NULL THEN '*' ELSE Product_Number END, '_',
        CASE WHEN Is_Product_Number_21076 IS NULL THEN '*' ELSE Is_Product_Number_21076 END
    ),
    Sorgu_Final = NULL,
    Any_Match   = NULL;

-- Q04 : 00200_a_Mother_Data_First_Mapping
/* DELETE FROM yy_10_a_Mother_Data_First_Mapping;

The query 04 is not necessary. We can create the structure of the table in the Q6 using 
SELECT INTO instead of using INSERT INTO. */

-- Q05 : 00200_b_Mother_Data_First_Mapping
SELECT
    fs.BBVA_Sequence_Distinct,
    fs.Group2 AS Group2_B,
    CASE
        WHEN fs.Group2 IN ('Loans and advances to customers', 'Loans and advances to banks')
            THEN 'Yes'
        ELSE 'No'
    END AS Is_Group2_Loans_and_advances_B,
    fs.Finrep_Sector AS Finrep_Sector_B,
    CASE
        WHEN fs.Used_Collateral_Type LIKE '%-101-%'
          OR fs.Used_Collateral_Type LIKE '%-102-%'
            THEN 'Yes'
        ELSE 'No'
    END AS Is_Collat_Type_101_102_B,
    fs.IFRS_P_S AS IFRS_P_S_B,
    fs.Product_Number AS Product_Number_B,
    CASE
        WHEN LTRIM(RTRIM(ISNULL(fs.Product_Number, ''))) = '21076'
            THEN 'Yes'
        ELSE 'No'
    END AS Is_Product_Number_21076_B
--INTO [MIDTABLES].[00200_b_Mother_Data_First_Mapping]
FROM [INPUTS].[yyy_30_BBVA_Financial_Statement] AS fs;


-- Q06 : 00200_c_Mother_Data_First_Mapping
SELECT
    b.BBVA_Sequence_Distinct as DATA_SequenceB,
    CONCAT(
        ISNULL(b.Group2_B, ''), '_',
        ISNULL(b.Is_Group2_Loans_and_advances_B, ''), '_',
        ISNULL(b.Finrep_Sector_B, ''), '_',
        ISNULL(b.Is_Collat_Type_101_102_B, ''), '_',
        ISNULL(b.IFRS_P_S_B, ''), '_',
        ISNULL(b.Product_Number_B, ''), '_',
        ISNULL(b.Is_Product_Number_21076_B, '')
    ) AS KeyB,
    b.Group2_B,
    b.Is_Group2_Loans_and_advances_B,
    b.Finrep_Sector_B,
    b.Is_Collat_Type_101_102_B,
    b.IFRS_P_S_B,
    b.Product_Number_B,
    b.Is_Product_Number_21076_B
--INTO [MIDTABLES].[yy_10_a_Mother_Data_First_Mapping]
FROM [MIDTABLES].[00200_b_Mother_Data_First_Mapping] AS b;


-- Q07 : 00210_a_Distinct_Mother_Data_First_Mapping 
/* Here We have the same case as in query 04, the tables will be created in the Q08.

DELETE FROM yy_10_b_Distinct_Mother_Data_First_Mapping; */

-- Q08 : 00210_b_Distinct_Mother_Data_First_Mapping

/* In this case, maybe we could change the GROUP BY for SELECT DISTINCT, but It's necessary the data for test it.
There is something strange about the [sequence] column because they didn't bring it, but in the next query they made a join using this field.*/
SELECT
    a.KeyB                              AS KeyC,
    a.Group2_B                          AS Group2_C,
    a.Is_Group2_Loans_and_advances_B    AS Is_Group2_Loans_and_advances_C,
    a.Finrep_Sector_B                   AS Finrep_Sector_C,
    a.Is_Collat_Type_101_102_B          AS Is_Collat_Type_101_102_C,
    a.IFRS_P_S_B                        AS IFRS_P_S_C,
    a.Product_Number_B                  AS Product_Number_C,
    a.Is_Product_Number_21076_B         AS Is_Product_Number_21076_C
INTO [MIDTABLES].[yy_10_b_Distinct_Mother_Data_First_Mapping]
FROM [MIDTABLES].[yy_10_a_Mother_Data_First_Mapping] AS a
GROUP BY
    a.KeyB,
    a.Group2_B,
    a.Is_Group2_Loans_and_advances_B,
    a.Finrep_Sector_B,
    a.Is_Collat_Type_101_102_B,
    a.IFRS_P_S_B,
    a.Product_Number_B,
    a.Is_Product_Number_21076_B;


--  Q08.5 : Module A01_Primary() 
/* Here is used the module for updating the table, IDK why, but we have to */
ALTER TABLE [MIDTABLES].[yy_10_b_Distinct_Mother_Data_First_Mapping]
ADD
    -- change the names and types below to what you need
    Summary_KeyC            NVARCHAR(200)   NULL,
    inflow_Account_C        INT             NULL,
    Any_Match             NVARCHAR(20)    NULL;

UPDATE d
SET d.Summary_KeyC = m.KeyA,
    d.inflow_Account_C = m.Inflow_Account,
    d.Any_Match = 'Yes'
FROM [MIDTABLES].[yy_10_b_Distinct_Mother_Data_First_Mapping] d
INNER JOIN [MIDTABLES].[0_a000_Inflow_Accounts_Mapping] m 
    ON d.KeyC LIKE m.KeyA
WHERE d.Summary_KeyC IS NULL;


-- Q09 : 00210_c_First_Mapping_DATA_UPDATE
UPDATE fsa
SET fsa.Liquidity_inflow_Account = d.inflow_Account_C
FROM [INPUTS].[yyy_30_BBVA_Financial_Statement_Additional] AS fsa
INNER JOIN [INPUTS].[yyy_30_BBVA_Financial_Statement] AS fs
    ON fsa.BBVA_Sequence_Distinct = fs.BBVA_Sequence_Distinct
INNER JOIN [MIDTABLES].[yy_10_a_Mother_Data_First_Mapping] AS a
    ON fs.BBVA_Sequence_Distinct = a.DATA_SequenceB
INNER JOIN [MIDTABLES].[yy_10_b_Distinct_Mother_Data_First_Mapping] AS d
    ON a.KeyB = d.KeyC
WHERE d.inflow_Account_C IS NOT NULL;
