using FluentValidation;
using IhmLlamaMvc.Application.Extensions;
using IhmLlamaMvc.Application.Validation;

namespace IhmLlamaMvc.Application.UseCases.Conversations.Commands;

/// <summary>
/// Représente le validateur de la classe  <see cref="CreerDemandeCommand"/>.
/// </summary>
public sealed class CreateQuestionRequeteValidator : AbstractValidator<CreerQuestionRequete>
{
    public CreateQuestionRequeteValidator()
    {

        RuleFor(x => x.Question)
            .NotNull()
            .NotEmpty()
            .WithError(ValidationErrors.Question.QuestionNotNull);

    }
}