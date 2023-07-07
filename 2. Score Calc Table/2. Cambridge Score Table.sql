/* --------------------------------------------------------------------------------------------------------------------------------------
To join prescription tables to latest phm table and to prepare columns to calculate patient score.
Run each section in order
For info on phm table see README
-----------------------------------------------------------------------------------------------------------------------------------------*/

/* --------------------------------------------------------------------------------------------------------------------------------------
Section 1: Create table and prepare columns for calculation
-----------------------------------------------------------------------------------------------------------------------------------------*/

IF OBJECT_ID('[AC].[ready].[cambridge_score]','U') IS NOT NULL DROP TABLE [AC].[ready].[cambridge_score]
select [nhs_number],
	   [practice_code],
-- Calculate Dementia (2.46)
CASE WHEN [qof_dementia] = 1 THEN 1
	 WHEN [cc_dementia] = 1 THEN 1 ELSE 0 END AS dementia,
-- Calculate Cancer (1.5)
CASE WHEN cancer_lung_year = 1 OR
					cancer_breast_year = 1 OR
					cancer_bowel_year = 1 OR
					cancer_prostate_year = 1 OR
					cancer_leuklymph_year = 1 OR
					cancer_cervical_year = 1 OR
					cancer_ovarian_year = 1 OR
					cancer_melanoma_year = 1 OR
					cancer_headneck_year = 1 OR
					cancer_giliver_year = 1 OR
					cancer_other_year = 1 OR
					cancer_bladder_year = 1 OR
					cancer_kidney_year = 1 THEN 1 ELSE 0 END AS cancer,
-- Calculate COPD (1.41)
CASE WHEN qof_copd = 1 THEN 1
	 WHEN cc_copd = 1 THEN 1 ELSE 0 END AS copd,
-- Calculate Atrial Fribrillation (1.3)
CASE WHEN qof_af = 1 THEN 1 ELSE 0 END AS atrial_fribrillation,
-- Calculate Parkinson's Disease (1.29)
CASE WHEN parkinsons = 1 THEN 1 ELSE 0 END AS parkinsons,
-- Calculate Heart Failure (1.12)
CASE WHEN qof_hf = 1 THEN 1
	 WHEN cc_heart_failure = 1 THEN 1 ELSE 0 END AS heart_failure,
-- Calculate Constipation (1.03)
CASE WHEN pxl.spec_l1b_PXLAX > 3 THEN 1 ELSE 0 END AS constipation,
-- Calculate Painful Conditions (0.87)
CASE WHEN pxpa.spec_l1b_PXPAIN > 3 THEN 1 ELSE 0 END AS painful_conditions,
-- Calculate Epilepsy (0.85)
CASE WHEN qof_epilepsy = 1 THEN 1 ELSE 0 END AS epilepsy,
	-- Calculate Stroke / TIA (0.77)
CASE WHEN qof_stroke = 1 THEN 1 
	 WHEN cc_stroke = 1 THEN 1 ELSE 0 END AS stroke_tia,
-- Calculate Liver Disease (0.72)
CASE WHEN cc_mild_liver_disease = 1 THEN 1
	 WHEN cc_moderate_or_severe_liver_disease = 1 THEN 1 ELSE 0 END AS liver_disease,
-- Calculate Diabetes (0.71)
CASE WHEN cc_diabetes_no_complications = 1 THEN 1
     WHEN cc_diabetes_end_complications = 1 THEN 1 ELSE 0 END AS diabetes,
-- Calculate MS (0.69)
CASE WHEN ms = 1 THEN 1 ELSE 0 END AS ms,
-- Calculate Bronchiectasis (0.66)
CASE WHEN cc_bronchiectasis = 1 THEN 1 ELSE 0 END AS bronchiectasis,	
-- Calculate Psychosis/BiPolar (0.58)
CASE WHEN qof_mental = 1 THEN 1 ELSE 0 END AS psychosis_bipolar,
-- Calculate Alcohol Problems (0.55)
CASE WHEN dep_alcohol = 1 THEN 1 ELSE 0 END AS alc_dependency,
-- Calculate Peripheral Vacular Disease (0.53)
CASE WHEN qof_pad = 1 THEN 1 
	 WHEN cc_periph_vasc = 1 THEN 1 ELSE 0 END AS periph_vascular,
-- Calculate CKD (0.51) 
CASE WHEN cc_egfr < 60 THEN 1 ELSE 0 END AS ckd,
-- Calculate Learning Disability (0.47)
CASE WHEN qof_learndis = 1 THEN 1 ELSE 0 END AS learning_dis,
-- Calculate Anxiety/Depression (0.47 weight)
CASE WHEN qof_depression = 1 THEN 1 
	 WHEN pxa.spec_l1b_PXANXDEP >3 THEN 1 ELSE 0 END AS anxiety_depression,
-- Calculate CHD (0.46)
CASE WHEN qof_chd = 1 THEN 1 
     WHEN cc_myocardial_infarction = 1 THEN 1 ELSE 0 END AS chd,
-- Calculate Inflammatory bowel disease  (0.44)
CASE WHEN ibd = 1 THEN 1 ELSE 0 END AS ibd,
-- Calculate Connective Tissue Disorder (0.4)
CASE WHEN qof_rheumarth = 1 THEN 1
	 WHEN inflam_arthritic = 1 THEN 1 ELSE 0 END AS connective_tissue_disorder,
-- Calculate Substance Misuse (0.38)
	CASE WHEN dep_opioid = 1 OR
			  dep_cocaine = 1 OR
			  dep_cannabis = 1 OR
			  dep_benzo = 1 OR
			  dep_benzo = 1 OR
			  dep_other = 1 THEN 1
		 WHEN pxd.spec_l1b_PXDRUGDEP > 3 THEN 1 ELSE 0 END AS substance_misus,
-- Calculate Anorexia or Bulimia (0.34)
	CASE WHEN disorder_eating = 1 THEN 1 ELSE 0 END AS anorexia_bulimia,
-- Calculate Eczema/Psoriasis (0.25)
	CASE WHEN eczema = 1 AND pxps.spec_l1b_PXPSORIASIS >3 THEN 1
		 WHEN psoriasis = 1 AND pxps.spec_l1b_PXPSORIASIS >3 THEN 1 ELSE 0 END AS eczaema_psoriasis,
-- Calculate Peptic Ulcer (0.2)
	CASE WHEN cc_peptic_ulcer = 1 THEN 1 ELSE 0 END AS peptic_ulcer,
-- Calculate IBS (0.18)
	CASE WHEN ibs = 1 THEN 1
		 WHEN pxi.spec_l1b_PXIBS >3 THEN 1 ELSE 0 END AS ibs,
-- Calculate Asthma (0.18)
	CASE WHEN qof_asthma = 1 THEN 1 
		 WHEN cc_asthma = 1 THEN 1 ELSE 0 END AS asthma,
-- Calculate Blindness / Low Sight (0.15)
	CASE WHEN visual_impair = 1 THEN 1 ELSE 0 END AS visual_impair,
-- Calculate Hypertension Score (0.09 weight)
	CASE WHEN qof_ht = 1 THEN 1 else 0 END AS hypertension,
-- Calculate Thyroid (0.08)
	CASE WHEN thyroid = 1 THEN 1
		 WHEN pxt.spec_l1b_PXTHYROID > 3 THEN 1 ELSE 0 END AS thyroid,
-- Calculate Migraine Score (0.07) 
	CASE WHEN pxm.spec_l1b_PXMIGRAINE > 3 THEN 1 ELSE 0 END AS migraine,
-- Calculate Hearing Loss Score (0.07)
	CASE WHEN hearing_impair = 1 THEN 1 ELSE 0 END AS hearing_loss,
-- Calculate Prostate (0.01)
	CASE WHEN pxp.spec_l1b_PXPROST > 3 THEN 1 ELSE 0 END AS prostate
	--0.00 as [Score]
Into [AC].[ready].[cambridge_score]
From [Population_Segmentation].[terminal].[attrib_202301_complete_date] att -- phm table see README for info
left join [AC].[ready].[PXANXDEP] pxa on att.nhs_number = pxa.pseudo_nhs 
left join [AC].[ready].[PXIBS] pxi on att.nhs_number = pxi.pseudo_nhs 
left join [AC].[ready].[PXPROST] pxp on att.nhs_number = pxp.pseudo_nhs 
left join [AC].[ready].[PXTHYROID] pxt on att.nhs_number = pxt.pseudo_nhs 
left join [AC].[ready].[PXPSORIASIS] pxps on att.nhs_number = pxps.pseudo_nhs 
left join [AC].[ready].[PXMIGRAINE] pxm on att.nhs_number = pxm.pseudo_nhs 
left join [AC].[ready].[PXLAX] pxl on att.nhs_number = pxl.pseudo_nhs 
left join [AC].[ready].[PXDRUGDEP] pxd on att.nhs_number = pxd.pseudo_nhs 
left join [AC].[ready].[PXPAIN] pxpa on att.nhs_number = pxpa.pseudo_nhs 
--(1048344 rows affected)



/* --------------------------------------------------------------------------------------------------------------------------------------
Section 2: Adding Score column
-----------------------------------------------------------------------------------------------------------------------------------------*/

ALTER TABLE [AC].[ready].[cambridge_score]
ADD [cambridge_score] DECIMAL(6,2);

/* --------------------------------------------------------------------------------------------------------------------------------------
Section 3: Setting the score column created above
-----------------------------------------------------------------------------------------------------------------------------------------*/

update [AC].[ready].[cambridge_score]
Set [cambridge_score] =  0.09 * hypertension  +
	0.47 * anxiety_depression  +
	0.07 * hearing_loss  +
	0.18 * ibs  +
	0.71 * diabetes  +
	0.01 * prostate  +
	0.08 * thyroid  +
	0.46 * chd  +
	0.51 * ckd  +
	1.3 * atrial_fribrillation  +
	1.03 * constipation  +
	0.77 * stroke_tia  +
	1.41 * copd  +
	0.4 * connective_tissue_disorder  +
	1.5 * cancer  +
	0.2 * peptic_ulcer  +
	0.55 * alc_dependency  +
	0.38 * substance_misus  +
	0.25 * eczaema_psoriasis  +
	0.15 * visual_impair  +
	1.12 * heart_failure  +
	2.46 * dementia  +
	0.58 * psychosis_bipolar  +
	0.85 * epilepsy  +
	0.44 * ibd  +
	0.53 * periph_vascular  +
	0.34 * anorexia_bulimia  +
	0.72 * liver_disease  +
	0.07 * migraine  +
	0.47 * learning_dis  +
	0.66 * bronchiectasis  +
	0.69 * ms  +
	1.29 * parkinsons  +
	0.18 * asthma  +
	0.87 * painful_conditions
--(1048344 rows affected)

/* --------------------------------------------------------------------------------------------------------------------------------------
Section 4: Adding Score Category column
-----------------------------------------------------------------------------------------------------------------------------------------*/

ALTER TABLE [AC].[ready].[cambridge_score]
ADD [score_category] DECIMAL(6,2);

/* --------------------------------------------------------------------------------------------------------------------------------------
Section 5: Setting the score category column created above
-----------------------------------------------------------------------------------------------------------------------------------------*/

--setting score category column
update [AC].[ready].[cambridge_score]
Set [score_category] =  CASE when [cambridge_score] < 0.09 then 1
	when [cambridge_score] >= 0.09 and [cambridge_score] < 0.69 then 2
	when [cambridge_score] >= 0.69 and [cambridge_score] < 1.58 then 3
	when [cambridge_score] >= 1.58 and [cambridge_score] < 2.96 then 4
	when [cambridge_score] >= 2.96 then 5
	END
--(1048344 rows affected)

