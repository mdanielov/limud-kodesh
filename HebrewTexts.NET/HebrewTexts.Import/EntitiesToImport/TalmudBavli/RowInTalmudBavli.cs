using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using FluentValidation;

namespace HebrewTexts.Import.EntitiesToImport.TalmudBavli
{
    public class RowInTalmudBavli
    {


        [Required]
        public AmudTalmudBavli InAmud { get; set; }

        [Required, Range(1, 300)]
        public int SequenceNumber { get; set; }
        [Required]
        [RegularExpression(@"^[א-ת ""':.]{1,200}$", ErrorMessage = "תוכן לא צפוי")]
        public string Content { get; set; }

        #region SuperGroupsHandling
        
        public int? StartMishnaBeforePositionInContent { get; set; }
        public int? EndMishnaAfterPositionInContent { get; set; }


        public int? StartGmaraBeforePositionInContent { get; set; }
        public int? EndGmaraAfterPositionInContent { get; set; }

        public int? StartChapterBeforePositionInContent { get; set; }
        public int? EndChapterAfterPositionInContent { get; set; }

        public string StartChapterName { get; set; }


        #endregion


        /// <summary>
        /// all validators of this entity
        /// </summary>
        public bool IsValid
        {
            get
            {
                var context = new System.ComponentModel.DataAnnotations.ValidationContext(this, null, null);
                var normalValid = Validator.TryValidateObject(this, context, null, true);

                //FluentValidator
                var validator = new RowInTalmudBavliValidator();
                var results = validator.Validate(this);

                return normalValid && results.IsValid;

            }
        }

        class RowInTalmudBavliValidator : AbstractValidator<RowInTalmudBavli>
        {
            public RowInTalmudBavliValidator()
            {
                //RuleFor(rw => rw.InAmud).Must(a => a.IsValid).WithMessage("עמוד לא תקין");
            }

        }


    }
}
