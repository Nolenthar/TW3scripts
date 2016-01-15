enum ESpendablePointType
{
	ESkillPoint,
	EExperiencePoint
}
struct SSpendablePoints
{
	saved var free	: int;
	saved var used	: int;
};
struct SLevelDefinition
{
	var number : int;
	var requiredTotalExp : int;
	var addedSkillPoints : int;
	var addedMutationPoints : int;
	var addedKnowledgePoints : int;
};
