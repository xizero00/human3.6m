db = H36MDataBase.instance();

ImageFeature = H36MRGBVideoFeature();
MaskFeature = H36MMyBBMask();

InputFeatures{1} = H36MHoGFeature('MaskFeature',MaskFeature,'ImageFeature',ImageFeature);
TargetFeatures{1} = H36MPose3DPositionsFeature('Monocular',true,'Relative',true,'Part','body');

MaskFeature.FeatureName
InputFeatures{1}.FeatureName
TargetFeatures{1}.FeatureName

s = RandStream.create('mt19937ar','seed',5489);
RandStream.setDefaultStream(s);


IKParam = 1.7;
switch method
	case 'none'
	case 'H36MBLKnn'
		setenv('OMP_NUM_THREADS','8');
		par_args = {'''dist''','''chi2''','''method''','''mean'''};
		
	case 'H36MBLKr'
		par_args = {'''dim''','size(Feats{1},2)','''IKType''','''exp_chi2''','''IKParam''',num2str(IKParam)};
		
	case 'H36MBLLinKrr'
		par_args = {'''dim''','size(Feats{1},2)','''IKType''','''exp_chi2''','''IKParam''',num2str(IKParam)};
	
	case 'H36MBLLinKrrNoBias'
		par_args = {'''dim''','size(Feats{1},2)','''IKType''','''exp_chi2''','''IKParam''',num2str(IKParam),'''lambda''','1250','''normalizeRF''','0'};
		
	case 'H36MBLKde'
		par_args = {'''dim''','size(Feats{1},2)','''IKType''','''exp_chi2''','''IKParam''',num2str(IKParam)};
		
	otherwise
		error('Unknown method!');
end


tag_base = 'alpha_test';
if exist('tag_cv','var')
	tag = [tag_base tag_cv];
else
	tag = tag_base ;
end

tag
