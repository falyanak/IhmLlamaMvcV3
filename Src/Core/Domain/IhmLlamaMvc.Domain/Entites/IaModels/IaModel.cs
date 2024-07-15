using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Domain.Entites.IaModels
{
    public class IaModel : EntityBase<int>
    {
        public string Type { get; set; }
        public string Version { get; set; }
    }
}
