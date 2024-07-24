using System.ComponentModel.DataAnnotations;

namespace IhmLlamaMvc.Mvc.ViewModels;

public class StatistiquesViewModel
{
    public StatistiquesViewModel()
    {
        var now = DateTime.Now;
        var dateBase = new DateTime(now.Year, now.Month, now.Day);
 
        DateDebut = dateBase.AddYears(-2); ;
        DateFin = dateBase.Add(new TimeSpan(23, 59, 59));
    }

    [Display(Name = "Du")]
    [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}")]
    public DateTime DateDebut { get; set; }

    [Display(Name = "au")]
    [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}")]
    public DateTime DateFin { get; set; }

}