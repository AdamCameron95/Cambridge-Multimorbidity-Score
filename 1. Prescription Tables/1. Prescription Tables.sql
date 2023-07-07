/* ------------------------------------------------------- CREATING PRESCRIPTION DATA ------------------------------------------------------
Creating prescription tables which need to be joined in 2. Cambridge score Table script to latest phm table.
Date needs +1 month (assuming run each month).
Filters on Pod_l1 and date can be deleted if run straight from emis data that only includes prescription data for last year

------------------------------------------------------------------ END ------------------------------------------------------------------*/
DECLARE @start_date date = '2022-02-01';
DECLARE @end_date date = '2023-01-31'


	--Create the anxiety depression table
    IF OBJECT_ID('[AC].[ready].[PXANXDEP]','U') IS NOT NULL DROP TABLE [AC].[ready].[PXANXDEP]
	SELECT pseudo_nhs, count(spec_l1b) AS 'spec_l1b_PXANXDEP'
	INTO [AC].[ready].[PXANXDEP]
	FROM Population_Segmentation.terminal.activ_all_monthly -- See read me for info on creation of this
	WHERE pod_l1 like 'primary_care_prescription'   AND arr_date BETWEEN @start_date and @end_date 
	AND	(spec_l1b like '%diazepam%'OR
	spec_l1b like '%alprazolam%'OR
	spec_l1b like '%chlordiazepoxide%'OR
	spec_l1b like '%clobazam%'OR
	spec_l1b like '%lorazepam%'OR
	spec_l1b like '%oxazepam%'OR
	spec_l1b like '%temazepam%'OR
	spec_l1b like '%zolpidem%'OR
	spec_l1b like '%zopiclone%'OR
	spec_l1b like '%sertraline%'OR
	spec_l1b like '%citalopram%'OR
	spec_l1b like '%dapoxetine%'OR
	spec_l1b like '%citalopram%'OR
	spec_l1b like '%fluoxetine%'OR
	spec_l1b like '%fluvoxamine%'OR
	spec_l1b like '%paroxetine%'OR
	spec_l1b like '%mirtazapine%'OR
	spec_l1b like '%venlafaxine%'OR
	spec_l1b like '%duloxetine%'OR
	spec_l1b like '%aripiprazole%'OR
	spec_l1b like '%olanzapine%'OR
	spec_l1b like '%quetiapine%'OR
	spec_l1b like '%risperidone%'OR
	spec_l1b like '%trazadone%')
	GROUP BY pseudo_nhs


	--Create the IBS prescription table
	IF OBJECT_ID('[AC].[ready].[PXIBS]','U') IS NOT NULL DROP TABLE [AC].[ready].[PXIBS]
	SELECT pseudo_nhs, count(spec_l1b) AS 'spec_l1b_PXIBS'
	INTO [AC].[ready].[PXIBS]
	FROM Population_Segmentation.terminal.activ_all_monthly 
	WHERE pod_l1 like 'primary_care_prescription' AND arr_date BETWEEN @start_date and @end_date
	AND (spec_l1b like '%hyoscine butylbromide%'OR
	spec_l1b like '%mebeverine%'OR
	spec_l1b like '%buscopan%')
	GROUP BY pseudo_nhs

	--Create the prostrate prescription table
	IF OBJECT_ID('[AC].[ready].[PXPROST]','U') IS NOT NULL DROP TABLE [AC].[ready].[PXPROST]
	SELECT pseudo_nhs, count(spec_l1b) AS 'spec_l1b_PXPROST'
	INTO [AC].[ready].[PXPROST]
	FROM Population_Segmentation.terminal.activ_all_monthly
	WHERE pod_l1 like 'primary_care_prescription' AND arr_date BETWEEN @start_date and @end_date
	 AND (spec_l1b like '%tamsulosin%'OR
	spec_l1b like '%alfuzosin%'OR
	spec_l1b like '%finasteride%'OR
	spec_l1b like '%dutasteride%')
	GROUP BY pseudo_nhs

	--Create the thyroid prescription table:
	IF OBJECT_ID('[AC].[ready].[PXTHYROID]','U') IS NOT NULL DROP TABLE [AC].[ready].[PXTHYROID]
	SELECT pseudo_nhs, count(spec_l1b) AS 'spec_l1b_PXTHYROID'
	INTO [AC].[ready].[PXTHYROID]
	FROM Population_Segmentation.terminal.activ_all_monthly
	WHERE pod_l1 like 'primary_care_prescription' AND arr_date BETWEEN @start_date and @end_date
	 AND (spec_l1b like '%levothyroxine%'OR
	spec_l1b like '%propylthiouracil%'OR
	spec_l1b like '%carbimazole%')
	GROUP BY pseudo_nhs

	--Create the eczema/psoriasis prescription table:

	IF OBJECT_ID('[AC].[ready].[PXPSORIASIS]','U') IS NOT NULL DROP TABLE [AC].[ready].[PXPSORIASIS]
	Select pseudo_nhs, count(spec_l1b) AS 'spec_l1b_PXPSORIASIS'
	INTO [AC].[ready].[PXPSORIASIS]
	FROM Population_Segmentation.terminal.activ_all_monthly
	WHERE pod_l1 like 'primary_care_prescription' AND arr_date BETWEEN @start_date and @end_date
	AND (spec_l1b like '%hydrocortisone 0.5%' OR
	spec_l1b like '%hydrocortisone 1%' OR
	spec_l1b like '%hydrocortisone 2.5%' OR
	spec_l1b like '%betamethasone valerate 0.025%' OR
	spec_l1b like '%clobetasone butyrate 0.05%' OR
	spec_l1b like '%betamethasone valerate 0.1%' OR
	spec_l1b like '%mometasone furoate 0.1%' OR
	spec_l1b like '%clobetasol propionate 0.1%' OR
	spec_l1b like '%Eumovate%' OR
	spec_l1b like '%Betnovate%' OR
	spec_l1b like '%Elocon%' OR
	spec_l1b like '%Dermovate%' OR
	spec_l1b like '%calcipotriol%' OR
	spec_l1b like '%coal tar%' OR
	spec_l1b like '%diprosalic%' OR
	spec_l1b like '%dithranol%' OR
	spec_l1b like '%dovobet%' OR
	spec_l1b like '%dovonex%' OR
	spec_l1b like '%salicylic acid%' OR
	spec_l1b like '%tacrolimus%')
	Group by pseudo_nhs

	--Create the migraine prescription table:

	IF OBJECT_ID('[AC].[ready].[PXMIGRAINE]','U') IS NOT NULL DROP TABLE [AC].[ready].[PXMIGRAINE]
	SELECT pseudo_nhs, count(spec_l1b) AS 'spec_l1b_PXMIGRAINE'
	INTO [AC].[ready].[PXMIGRAINE]
	FROM Population_Segmentation.terminal.activ_all_monthly
	WHERE pod_l1 like 'primary_care_prescription' AND arr_date BETWEEN @start_date and @end_date
	AND (spec_l1b like '%sumatriptan %' OR
	spec_l1b like '%eletriptan%' OR
	spec_l1b like '%frovatriptan%' OR
	spec_l1b like '%naratriptan%' OR
	spec_l1b like '%rizatriptan%' OR
	spec_l1b like '%zolmitriptan%')
	GROUP BY pseudo_nhs


	--Create the  laxative table:

	IF OBJECT_ID('[AC].[ready].[PXLAX]','U') IS NOT NULL DROP TABLE [AC].[ready].[PXLAX]
	SELECT pseudo_nhs, count(spec_l1b) AS 'spec_l1b_PXLAX'
	INTO [AC].[ready].[PXLAX]
	FROM Population_Segmentation.terminal.activ_all_monthly
	WHERE pod_l1 like 'primary_care_prescription' AND arr_date BETWEEN @start_date and @end_date
	AND (spec_l1b like '%lactulose%'OR
	spec_l1b like '%senna%'OR
	spec_l1b like '%movicol%'OR
	spec_l1b like '%macrogol%'OR
	spec_l1b like '%cosmocol%'OR
	spec_l1b like '%laxido%'OR
	spec_l1b like '%ispaghula husk%'OR
	spec_l1b like '%fybogel%'OR
	spec_l1b like '%prucalopride%'OR
	spec_l1b like '%docusate sodium%'OR
	spec_l1b like '%sodium docusate%'OR
	spec_l1b like '%bisacodyl%'OR
	spec_l1b like '%co-danthramer%'OR
	spec_l1b like '%arachis oil enema%'OR
	spec_l1b like '%sodium citrate micro-enema%'OR
	spec_l1b like '%phosphate enema%'OR
	spec_l1b like '%glycerol suppository%')
	GROUP BY pseudo_nhs


	--Create the drug dependency table:

	IF OBJECT_ID('[AC].[ready].[PXDRUGDEP]','U') IS NOT NULL DROP TABLE [AC].[ready].[PXDRUGDEP]
	SELECT pseudo_nhs, count(spec_l1b) AS 'spec_l1b_PXDRUGDEP'
	INTO [AC].[ready].[PXDRUGDEP]
	FROM Population_Segmentation.terminal.activ_all_monthly
	WHERE pod_l1 like 'primary_care_prescription' AND arr_date BETWEEN @start_date and @end_date
	 AND (spec_l1b like '%methadone%')
	GROUP BY pseudo_nhs

	--Create the Painful Conditions prescription table:


	IF OBJECT_ID('[AC].[ready].[PXPAIN]','U') IS NOT NULL DROP TABLE [AC].[ready].[PXPAIN]
	SELECT act.pseudo_nhs, count(spec_l1b) AS 'spec_l1b_PXPAIN'
	INTO [AC].[ready].[PXPAIN]
	FROM Population_Segmentation.terminal.activ_all_monthly act 
	LEFT JOIN [Population_Segmentation].[terminal].[attrib_202301_complete_date] /*for info on this table see README in 2. folder */ att ON act.pseudo_nhs = att.nhs_number 
	WHERE pod_l1 like 'primary_care_prescription' AND arr_date BETWEEN @start_date and @end_date
	AND (spec_l1b like '%paracetamol%' OR
       spec_l1b like '%ibuprofen%' OR
       spec_l1b like '%naproxen%' OR
       spec_l1b like '%diclofenac%' OR
       spec_l1b like '%meloxicam%' OR
       spec_l1b like '%indometacin%' OR
       spec_l1b like '%mefenamic acid%' OR
       spec_l1b like '%ketoprofen%' OR
       spec_l1b like '%celecoxib%' OR
       spec_l1b like '%etoricoxib%' OR
       spec_l1b like '%co-codamol%' OR
       spec_l1b like '%co-dydramol%' OR
       spec_l1b like '%co-proxamol%' OR
       spec_l1b like '%codeine%' OR
       spec_l1b like '%dihydrocodeine%' OR
       spec_l1b like '%tramadol%' OR
       spec_l1b like '%morphine%' OR
       spec_l1b like '%morphine sulfate%' OR
       spec_l1b like '%buprenorphine%' OR
       spec_l1b like '%fentanyl%' OR
       spec_l1b like '%diamorphine%' OR
       spec_l1b like '%oxycodone%' OR
       spec_l1b like '%amitriptyline%' OR
       (spec_l1b like '%pregabalin%' AND att.epilepsy IS NULL AND att.qof_epilepsy IS NULL) OR
       (spec_l1b like '%gabapentin%' AND att.epilepsy IS NULL AND att.qof_epilepsy IS NULL) OR
       spec_l1b like '%Panadol%' OR
       spec_l1b like '%Ibucalm%' OR
       spec_l1b like '%Ibular%' OR
       spec_l1b like '%Nurofen%' OR
       spec_l1b like '%Brufen%' OR
       spec_l1b like '%Cuprofen%' OR
       spec_l1b like '%Ibugel%' OR
       spec_l1b like '%Ibuleve%' OR
       spec_l1b like '%Phorpain%' OR
       spec_l1b like '%Fenbid%' OR
       spec_l1b like '%Naprosyn%' OR
       spec_l1b like '%Dicloflex%' OR
       spec_l1b like '%Enstar XL%' OR
       spec_l1b like '%Diclomax%' OR
       spec_l1b like '%Motifene%' OR
       spec_l1b like '%Voltarol%' OR
       spec_l1b like '%Ponstan%' OR
       spec_l1b like '%Oruvail%' OR
       spec_l1b like '%Larafen%' OR
       spec_l1b like '%Celebrex%' OR
       spec_l1b like '%Arcoxia%' OR
       spec_l1b like '%Solpadeine%' OR
       spec_l1b like '%Codipar%' OR
       spec_l1b like '%Emcozin%' OR
       spec_l1b like '%Kapake%' OR
       spec_l1b like '%Solpadol%' OR
       spec_l1b like '%Zapain%' OR
       spec_l1b like '%Zipamol%' OR
       spec_l1b like '%Tylex%' OR
       spec_l1b like '%Paramol%' OR
       spec_l1b like '%Remedeine%' OR
       spec_l1b like '%DHC Continus%' OR
       spec_l1b like '%Zydol%' OR
       spec_l1b like '%Zamadol%' OR
       spec_l1b like '%Brimisol%' OR
       spec_l1b like '%Invodol%' OR
       spec_l1b like '%Marol%' OR
       spec_l1b like '%Tilodol%' OR
       spec_l1b like '%Tradorec%' OR
       spec_l1b like '%Tramulief%' OR
       spec_l1b like '%Maxitram%' OR
       spec_l1b like '%Tramquel%' OR
       spec_l1b like '%Sevredol%' OR
       spec_l1b like '%MST Continus%' OR
       spec_l1b like '%Morphgesic%' OR
       spec_l1b like '%Zomorph%' OR
       spec_l1b like '%Oramorph%' OR
       spec_l1b like '%BuTrans%' OR
       spec_l1b like '%Bunov%' OR
       spec_l1b like '%Bupramyl%' OR
       spec_l1b like '%Butec%' OR
       spec_l1b like '%Panitaz%' OR
       spec_l1b like '%Rebrikel%' OR
       spec_l1b like '%Reletrans%' OR
       spec_l1b like '%Sevodyne%' OR
       spec_l1b like '%Bupeaze%' OR
       spec_l1b like '%Carlosafine%' OR
       spec_l1b like '%Hapoctasin%' OR
       spec_l1b like '%Relevtec%' OR
       spec_l1b like '%Oxyact%' OR
       spec_l1b like '%Ixyldone%' OR
       spec_l1b like '%Longtec%' OR
       spec_l1b like '%Oxeltra%' OR
       spec_l1b like '%OxyContin%' OR
       spec_l1b like '%Oxylan%' OR
       spec_l1b like '%Oxypro%' OR
       spec_l1b like '%Reltebon%' OR
       spec_l1b like '%Renocontin%' OR
       spec_l1b like '%Leveraxo%' OR
       spec_l1b like '%Lynlor%' OR
       spec_l1b like '%OxyNorm%' OR
       (spec_l1b like '%Alzain%' AND att.epilepsy IS NULL AND att.qof_epilepsy IS NULL) OR
       (spec_l1b like '%Axalid%' AND att.epilepsy IS NULL AND att.qof_epilepsy IS NULL) OR
       (spec_l1b like '%Lyrica%' AND att.epilepsy IS NULL AND att.qof_epilepsy IS NULL) OR
       (spec_l1b like '%Neurontin%' AND att.epilepsy IS NULL AND att.qof_epilepsy IS NULL)
       )
       and not spec_l1b like '%Medroxyprogesterone%'
	GROUP BY act.pseudo_nhs



