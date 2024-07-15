DROP VIEW  IF EXISTS  dbo.V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL
GO
-- Create the view in the specified schema
CREATE VIEW dbo.V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL
AS
/*   
Auteur: ZA 13/01/2023: Initialisation et première version
-------------------------------------------------------------------------------------------------------
Description : Retourne la liste des affectations par entité : SCL, DGDDI, DGAL
-------------------------------------------------------------------------------------------------------
Modification : 

    ZA 22/02/2023: Ajout de TUNFCT_IDENT=32 pour récupérer les nouvelles unités DGAL
    ZA 22/02/2023: Jointure avec la table UNITE_FONCTIONNELLE_AUTRES_INFOS pour récupérer les colonnes ActiveDirectoryOU, ContactOU et GroupeOU
    ZA 24/02/2023: Correction de la partie permettant de renvoyer les informations du SCL
    ZA 19/06/2023: Suppression des unités DEETS971 DEETS972 DGCOPOP 973 DEETS974 DCSTEP975 DEETS976 de la liste déroulante des unités fonctionnelles. 

  
-- Test
SELECT * FROM V_Profil_Plus_UO_UA_DGDDI_SCL_DGAL
-------------------------------------------------------------------------------------------------------
*/
select 'DGDDI' as Entite,
    u.unfct_ident as UniteFonctionnelleId,
    u.UNFCT_LIBC_UNITE  as UniteFonctionnelle,
    u.unfct_ident as UniteAdministrativeId,
    u.UNFCT_LIBC_UNITE  as UniteAdministrative,
    ufautre.ActiveDirectoryOU as ActiveDirectoryOU,
    ufautre.ContactOU as ContactOU,
    ufautre.GroupeOU as GroupeOU,
    ufautre.GroupeOU2 as GroupeOU2
from unite_fonctionnelle u
LEFT OUTER JOIN UNITE_FONCTIONNELLE_AUTRES_INFOS ufautre ON (u.UNFCT_IDENT = ufautre.UNFCT_IDENT)
where u.TUNFCT_IDENT = 26 and u.UNFCT_FLAG_OBSOLET =0


UNION

select  'DGAL' as Entite,
    u.unfct_ident as UniteFonctionnelleId, 
    u.UNFCT_LIBC_UNITE  as UniteFonctionnelle,
    u.unfct_ident as UniteAdministrativeId, 
    u.UNFCT_LIBC_UNITE  as UniteAdministrative,
    ufautre.ActiveDirectoryOU as ActiveDirectoryOU,
    ufautre.ContactOU as ContactOU,
    ufautre.GroupeOU as GroupeOU,
    ufautre.GroupeOU2 as GroupeOU2
from unite_fonctionnelle u 
LEFT OUTER JOIN UNITE_FONCTIONNELLE_AUTRES_INFOS ufautre ON (u.UNFCT_IDENT = ufautre.UNFCT_IDENT)
where u.TUNFCT_IDENT  in (27,28,31,32) and u.UNFCT_FLAG_OBSOLET =0

UNION

select  'DGAL' as Entite,
    u.unfct_ident as UniteFonctionnelleId, 
    u.UNFCT_LIBC_UNITE  as UniteFonctionnelle,
    u.unfct_ident as UniteAdministrativeId, 
    u.UNFCT_LIBC_UNITE  as UniteAdministrative,
    ufautre.ActiveDirectoryOU as ActiveDirectoryOU,
    ufautre.ContactOU as ContactOU,
    ufautre.GroupeOU as GroupeOU,
    ufautre.GroupeOU2 as GroupeOU2
from unite_fonctionnelle u 
LEFT OUTER JOIN UNITE_FONCTIONNELLE_AUTRES_INFOS ufautre ON (u.UNFCT_IDENT = ufautre.UNFCT_IDENT)
where u.TUNFCT_IDENT  in (1) and u.UNFCT_FLAG_OBSOLET =0  AND u.UNFCT_IDENT NOT IN (107,108,109,110,111,379) --  pour ne pas récupérer les DEETS

UNION
select  'SCL' as Entite,
    u.unfct_ident as UniteFonctionnelleId, 
    u.UNFCT_LIBC_UNITE  as UniteFonctionnelle,
    ufSCL.unfct_ident as UniteAdministrativeId, 
    ufSCL.UNFCT_LIBC_UNITE  as UniteAdministrative,
    ufautre.ActiveDirectoryOU as ActiveDirectoryOU,
    ufautre.ContactOU as ContactOU,
    ufautre.GroupeOU as GroupeOU,
    ufautre.GroupeOU2 as GroupeOU2
from  unite_fonctionnelle  as ufSCL, unite_fonctionnelle as u
LEFT OUTER JOIN UNITE_FONCTIONNELLE_AUTRES_INFOS ufautre ON (u.UNFCT_IDENT = ufautre.UNFCT_IDENT)
where u.TUNFCT_IDENT  in (6,24)  
and u.UNFCT_FLAG_OBSOLET =0
and ufSCL.UNFCT_IDENT=352

GO