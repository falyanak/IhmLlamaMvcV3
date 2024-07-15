using FluentValidation;
using IhmLlamaMvc.Application.Extensions;
using IhmLlamaMvc.Application.Validation;
using IhmLlamaMvc.Domain.Constants;
using IhmLlamaMvc.SharedKernel.Tools;

namespace IhmLlamaMvc.Application.UseCases.Agents.Commands;

/// <summary>
/// Représente le validateur de la classe  <see cref="CreerDemandeCommand"/>.
/// </summary>
public sealed class CreateAgentRequeteValidator : AbstractValidator<CreerAgentRequete>
{

    public CreateAgentRequeteValidator()
    {

        RuleFor(x => x.Nom)
            .NotNull()
            .NotEmpty()
            .WithError(ValidationErrors.Agent.AgentNomNotNull)
            .Matches(Constantes.IdentiteCaracteresAutorises)
            .WithError(ValidationErrors.Agent.NomAvecCaracteresSpeciaux)
            .Must(nom => StringUtilities.ContientPlusieursCaracteresConsecutifsIdentiques(nom))
            .WithError(ValidationErrors.Agent.NomRepetitionCaracteresIdentiquesConsecutifsPlusDe2Fois);

        RuleFor(x => x.Prenom)
            .NotNull()
            .NotEmpty()
            .WithError(ValidationErrors.Agent.AgentPrenomNotNull)
            .Matches(Constantes.IdentiteCaracteresAutorises)
            .WithError(ValidationErrors.Agent.PrenomAvecCaracteresSpeciaux)
            .Must(prenom => StringUtilities.ContientPlusieursCaracteresConsecutifsIdentiques(prenom))
            .WithError(ValidationErrors.Agent.PrenomRepetitionCaracteresIdentiquesConsecutifsPlusDe2Fois);

    }
}