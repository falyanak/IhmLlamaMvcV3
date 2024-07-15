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
        /// <summary>
        /// L'entité demandée n'est pas autorisée.
        /// </summary>
        internal static Error EntiteNotInList =>
            new Error("Agent.EntiteNotInList", "L'entité demandée n'est pas autorisée.");

        /// <summary>
        /// L'entité de l'agent ne doit pas être nulle
        /// </summary>
        internal static Error EntiteNotNull =>
            new Error("Agent.EntiteNotNull", "L'entité est obligatoire.");

        internal static Error CompteAdNotNull =>
            new Error("Agent.CompteAdNotNull", "Le compte Active Directory est obligatoire.");

        internal static Error CourrielNotNull =>
            new Error("Agent.CourrielNotNull", "Le compte de messagerie est obligatoire.");

        /// <summary>
        /// Le nom de l'agent doit être renseigné
        /// </summary>
        internal static Error NotNull => new Error("Agent.NotNull", "Le nom est obligatoire.");

        internal static Error AgentIdentifiantNotNull =>
            new Error("Agent.AgentIdentifiantNotNull",
                "L'identifiant de l'agent est obligatoire.");
    }
}