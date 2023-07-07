--Table referenced to create these group by tables (Population_Segmentation.terminal.activ_all_monthly) is a table consisting of all patient activity,
but we only use the 'primary care prescription' aspect of it for cambridge score calc. 
Emis search in Prescription folder (PHM_PX). Therefore new table will need to be created with prescription
data in. Something like:
SELECT [Patient Details' NHS Number]	AS pseudo_nhs
			,CONVERT (DATE, [Date of Issue])			AS temp_arr_date
			,[Name, Dosage and Quantity]				AS spec_l1b
INTO /*TABLE NAME*/
FROM /*PHM_Px EMIS Search Data*/ 
 
-- Date filter optional as EMIS search may only be for last year anyway

-- For info on [Population_Segmentation].[terminal].[attrib_202301_complete_date] (join in painful conditions prescription table) see README in 2.folder

--Contact adam.cameron@onecare.org.uk if further clarity needed