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
    internal static class Question
    {
        internal static Error QuestionNotNull =>
                   new Error("Question.QuestionNotNull",
                       "Le libellé d'une question est obligatoire.");

    }
}