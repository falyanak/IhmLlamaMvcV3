using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Application.Validation;

/// <summary>
/// Contains the application layer validation errors.
/// </summary>
internal static partial class ValidationErrors
{
    /// <summary>
    /// Contains the race validation errors.
    /// </summary>
    internal static class Agent
    {
  
        internal static Error AgentNomNotNull =>
            new Error("Agent.AgentNomNotNull",
                "Le nom de l'agent est obligatoire.");

        internal static Error AgentPrenomNotNull =>
            new Error("Agent.AgentPrenomNotNull",
                "Le prénom de l'agent est obligatoire.");

        internal static Error NomAvecCaracteresSpeciaux =>
            new Error("Demande.NomFamilleAvecCaracteresSpeciaux",
                "Le nom comporte des caractères spéciaux !");

        internal static Error PrenomAvecCaracteresSpeciaux =>
            new Error("Demande.PrenomAvecCaracteresSpeciaux",
                "Le prénom comporte des caractères spéciaux !");

        internal static Error NomRepetitionCaracteresIdentiquesConsecutifsPlusDe2Fois =>
            new Error("Demande.NomRepetitionCaracteresIdentiquesConsecutifsPlusDe2Fois",
                "Un caractère identique consécutif a été répété plus " +
                "de 2 fois dans le nom !");
        internal static Error PrenomRepetitionCaracteresIdentiquesConsecutifsPlusDe2Fois =>
            new Error("Demande.PrenomRepetitionCaracteresIdentiquesConsecutifsPlusDe2Fois",
                "Un caractère identique consécutif a été répété plus" +
                " de 2 fois dans le prénom !");

        internal static Error PrenomObligatoire =>
            new Error("Demande.PrenomObligatoire",
                "Le prénom de l'agent est obligatoire !");
    }
}