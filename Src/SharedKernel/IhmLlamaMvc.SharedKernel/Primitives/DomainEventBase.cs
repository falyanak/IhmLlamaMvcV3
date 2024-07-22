using MediatR;
using System.ComponentModel.DataAnnotations.Schema;

namespace IhmLlamaMvc.SharedKernel.Primitives;

[NotMapped]
public abstract class DomainEventBase : INotification
{
  public DateTime EventDate { get; protected set; } = DateTime.UtcNow;
}