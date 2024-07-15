DROP VIEW  IF EXISTS  dbo.V_Profil_Plus_EtatCourantDemande
GO
-- Create the view in the specified schema
CREATE VIEW dbo.V_Profil_Plus_EtatCourantDemande
AS
/*   
Auteur: ZA 13/01/2023: Initialisation et première version
-------------------------------------------------------------------------------------------------------
Description : Retourne le dernier état d'une demande
-------------------------------------------------------------------------------------------------------
Modification : 
mise en commentaire pour récupérer le dernier état d'une demande
	--
Test :
-------------------------------------------------------------------------------------------------------
*/

SELECT EtatDem.PFL_PLUS_DemandeIdent, MAX(EtatDem.DateEtatDemande) AS DateEtatCourant FROM PROFIL_PLUS_SuiviEtatDemande EtatDem
GROUP BY PFL_PLUS_DemandeIdent

GO

