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
    internal static class ChatMessage
    {
        /// <summary>
        /// La saisie d'une question est obligatoire
        /// </summary>
        internal static Error UniteFonctionnelleIdObligatoire =>
            new Error("ChatMessage.SaisieQuestionObligatoire",
                "La saisie d'une question est obligatoire");
   }
}