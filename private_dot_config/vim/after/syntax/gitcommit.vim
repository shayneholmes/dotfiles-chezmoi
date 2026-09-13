" Adjust the match to get the full fifty characters
syn match   gitcommitSummary	"^.*\%<51v." contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell
