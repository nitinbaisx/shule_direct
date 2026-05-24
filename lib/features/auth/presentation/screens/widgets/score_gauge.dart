import 'package:shule_direct/core/constants/import_files.dart';

class ScoreGauge extends StatelessWidget {
  const ScoreGauge({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: 0.75,
              strokeWidth: 10,
              backgroundColor: AppColors.gaugeBase,
              color: AppColors.primary,
            ),
          ),
          AppText(
            '75%',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
