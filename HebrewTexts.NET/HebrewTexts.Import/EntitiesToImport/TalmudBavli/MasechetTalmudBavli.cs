using FluentValidation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Import.EntitiesToImport.TalmudBavli
{
    public class MasechetTalmudBavli
    {
        [Required]
        public string Name { get; set; }

        [Required]
        [Range(1, 37)]
        public int SequenceNumber { get; set; }

        public List<AmudTalmudBavli> Amudim { get; set; } = new List<AmudTalmudBavli>();


        /// <summary>
        /// all validators of this entity
        /// </summary>
        public bool IsValid
        {
            get
            {
                var results = new List<ValidationResult>();
                //dot net validator
                var context = new System.ComponentModel.DataAnnotations.ValidationContext(this, null, null);
                var normalValid = Validator.TryValidateObject(this, context, results, true);

                //FluentValidator
                var validator = new MasechetTalmudBavliValidator();
                var fluentresults = validator.Validate(this);

                //מעדכן את הכשלים
                ValidationsMessages.Clear();

                ValidationsMessages.AddRange(results.Select(r => r.ErrorMessage));
                ValidationsMessages.AddRange(fluentresults.Errors.Select(e => e.ErrorMessage));
                var amudimValid = true;
                // בודק אם בעמודים הכל בסדר
                if (Amudim.Any(a=>!a.IsValid))
                {
                    amudimValid = false;
                    ValidationsMessages.Add("בעיה בוולידציה בעמודים");
                }
                return normalValid && fluentresults.IsValid && amudimValid;

            }
        }

        public List<string> ValidationsMessages { get; set; } = new List<string>();

        public override string ToString()
        {
            return Name;
        }

    }


    class MasechetTalmudBavliValidator : AbstractValidator<MasechetTalmudBavli>
    {
        public MasechetTalmudBavliValidator()
        {

            //מסכת חייבת להתחיל בדף ב
            RuleFor(masechet => masechet.Amudim).Must(a => a.Min(am => am.DafNumber) == 2).WithMessage("המסכת לא מתחילה בדף ב");

            //כמות מינימום ומקסימום של דפים למסכת
            //מסכת תמיד יש לה 8 דפים ומסכת בבא בתרא 175 דפים אז זהו הטווח המותר
            RuleFor(masechet => masechet.Amudim).Must(a => a.Select(am => am.DafNumber).Distinct().Count() >= 8 && a.Select(am => am.DafNumber).Distinct().Count() <= 175).WithMessage("מעט מידי או יותר מידי דפים למסכת זו");

            //חובה שהדפים יהיו ברצף מספרי
            RuleFor(masechet => masechet.Amudim).Must(a => a.Count > 0 &&
            Enumerable.Range(a.Min(mn => mn.DafNumber), a.Max(mx => mx.DafNumber) - (a.Min(mn => mn.DafNumber) - 1)) //יוצר רצף מספרי לפי הדף הראשון והאחרון
            .Except(a.Select(am => am.DafNumber).Distinct().ToList())//מהרצף הזה מוציא את כל הדפים הקיימים
            .ToList().Count == 0)//תוצאת הספירה צריכה להיות אפס הואיל ואם יש דפים ברצף ללא דילוג כולם אמורים לצאת מן הרשימה
            .WithMessage("אין רצף של דפים נמצא דילוג של דפים");


            //איסור על כפילות דף ועמוד
            RuleFor(masechet => masechet.Amudim).Must(a =>
              a.GroupBy(x => new { x.DafNumber, x.AmudNumber })
                .Where(g => g.Count() > 1)
                .ToList().Count == 0
                ).WithMessage("נמצאו עמודים כפולים לפי מספר דף ועמוד");

            //בכל הדפים חובה שיהיה שני עמודים עמוד א ועמוד ב
            //הדף היחידי שמותר שיהיה לו עמוד אחד בלבד הוא הדף האחרון וחובה שיהיה לו עמוד א
            RuleFor(masecet => masecet.Amudim).Must(a =>
             a.Count(am => am.AmudNumber == 1) == a.Select(am => am.DafNumber).Distinct().Count() //חובה שיהיו עמודי אלף כמניין הדפים
).WithMessage("חסר עמוד א באחד מהדפים");


            RuleFor(masecet => masecet.Amudim).Must(a =>
             (a.Count(am => am.AmudNumber == 2) == a.Select(am => am.DafNumber).Distinct().Count() //חובה שיהיו עמודי ב בכל הדפים 
             && a.OrderBy(am => am.DafNumber).ThenBy(am => am.AmudNumber).Last().AmudNumber == 2)//אם יש עמוד ב בדף האחרון צריך להיות בכל העמודים עמוד ב
             || //אם אין עמוד ב בדף האחרון אזי צריך שיהיו עמודי ב כמניין הדפים מינוס אחד
             (a.Count(am => am.AmudNumber == 2) == (a.Select(am => am.DafNumber).Distinct().Count() - 1) //חובה שיהיו עמודי ב בכל הדפים מלבד בדף האחרון
             && a.OrderBy(am => am.DafNumber).ThenBy(am => am.AmudNumber).Last().AmudNumber == 1)//אם העמוד האחרון במסכת הוא עמוד א אזי צריכים אנו עמוד ב 
                ).WithMessage("חסר עמוד ב באחד מהדפים");


        }

    }


}
