using System.ComponentModel;

namespace IhmLlamaMvc.SharedKernel.Tools;

public static class EnumHelper
{
    // afficher la chaine associée à une énumération avec l'annotation GetDescription
    //public static string GetDescription(System.Enum value)
    //{
    //    var enumMember = value.GetType().GetMember(value.ToString()).FirstOrDefault();
    //    var descriptionAttribute =
    //        enumMember == null
    //            ? default(DescriptionAttribute)
    //            : enumMember.GetCustomAttribute(typeof(DescriptionAttribute)) as DescriptionAttribute;
    //    return
    //        descriptionAttribute == null
    //            ? value.ToString()
    //            : descriptionAttribute.Description;
    //}

    public static string GetDescription<T>(this T enumValue) where T : struct, IConvertible
    {
        if (!typeof(T).IsEnum)
            throw new ArgumentException("T doit être une énumération!");

        var description = enumValue.ToString();
        var fieldInfo = enumValue.GetType().GetField(enumValue.ToString()!);

        if (fieldInfo != null)
        {
            var attrs =
                fieldInfo.GetCustomAttributes(typeof(DescriptionAttribute), true);

            if (attrs.Length > 0)
            {
                description = ((DescriptionAttribute)attrs[0]).Description;
            }
        }

        return description!;
    }
}