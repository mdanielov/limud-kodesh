
using FluentValidation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Import.EntitiesToImport.TalmudBavli
{
    public class AmudTalmudBavli
    {
        public string Version;
        public string BookPublishing;
        public string ResourceType;
        public string RefUri;
        public string HandlingBy;
        public DateTime DateCreated;
        public DateTime LastModified;

        /// <summary>
        /// אובייקט מסכת שבתוכו נמצא העמוד
        /// </summary>
        [Required]
        public MasechetTalmudBavli Masechet { get; set; }

        /// <summary>
        /// באיזה דף מדובר
        /// דף ב הוא 2 ג=3 וכן הלאה
        /// </summary>
        [Required]
        [Range(2, 159)]
        public int DafNumber { get; set; }

        /// <summary>
        /// איזה עמוד א או ב
        /// </summary>
        [Required]
        [Range(1, 2)]
        public int AmudNumber { get; set; }


        /// <summary>
        /// השורות בעמוד
        /// </summary>
        public List<RowInTalmudBavli> Rows { get; set; } = new List<RowInTalmudBavli>();

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
                var validator = new AmudTalmudBavliValidator();
                var fluentresults = validator.Validate(this);

                //מעדכן את הכשלים
                ValidationsMessages.Clear();

                ValidationsMessages.AddRange(results.Select(r => r.ErrorMessage));
                ValidationsMessages.AddRange(fluentresults.Errors.Select(e => e.ErrorMessage));
                // בודק אם הכל בסדר בשורות
                var RowsIsValid = true;
                if (Rows.Any(r=>!r.IsValid))
                {
                    RowsIsValid = false;
                    ValidationsMessages.Add("בעיות ולידציה בשורות");
                }
                return normalValid && fluentresults.IsValid && RowsIsValid;

            }
        }

        public List<string> ValidationsMessages { get; set; } = new List<string>();

    }


    class AmudTalmudBavliValidator : AbstractValidator<AmudTalmudBavli>
    {
        public AmudTalmudBavliValidator()
        {
            //חובה להכניס שורות בעמוד
            RuleFor(amud => amud.Rows).Must(r => r.Count > 0).WithMessage("לא נמצאו שורות בעמוד זה");

            //חובה שהשורות יהיו ברצף מספרי
            RuleFor(amud => amud.Rows).Must(r => r.Count > 0 &&
            Enumerable.Range(r.Min(mn => mn.SequenceNumber), r.Max(mx => mx.SequenceNumber))
            .Except
            (r.Select(rw => rw.SequenceNumber).ToList()).ToList().Count == 0
            ).WithMessage("אין רצף של שורות נמצא דילוג של שורות");

            //איסור על שורה כפולה
            RuleFor(amud => amud.Rows).Must(r =>
              r.GroupBy(x => x.SequenceNumber)
                .Where(g => g.Count() > 1)
                .ToList().Count == 0
                ).WithMessage("נמצאו שורות כפולות לפי מספר השורה");

        }

    }

}
