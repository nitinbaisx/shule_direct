import 'package:shule_direct/core/constants/import_files.dart';
import 'widgets/score_gauge.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: AppStatusBarScaffold.light(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go('/conversations');
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const AppText(
                      'Welcome to shule direct',
                      textAlign: TextAlign.center,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 24),
                    const Center(child: ScoreGauge()),
                    const SizedBox(height: 32),
                    AppLabeledField(
                      label: 'Email/Username',
                      field: AppTextField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        fillColor: AppColors.emailPasswordColor,
                      ),
                    ),
                    if (state is AuthError) ...[
                      const SizedBox(height: 8),
                      AppText(
                        state.message,
                        fontSize: 13,
                        color: AppColors.errorColor,
                      ),
                    ],
                    const SizedBox(height: 16),
                    AppLabeledField(
                      label: 'Password',
                      field: AppTextField(
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        obscureText: _obscurePassword,
                        fillColor: AppColors.emailPasswordColor,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    AppTextButton(
                      label: 'Forgot Password?',
                      alignment: Alignment.centerRight,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 24),
                    AppPrimaryButton(
                      label: 'Continue',
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        context.read<AuthCubit>().login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText("Don't have an account? "),
                        AppLinkText(
                          label: 'Register Now',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                          'All Rights Reserved (C) shule direct',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'shule\n',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'direct',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   bool _obscurePassword = true;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => sl<AuthCubit>(),
//       child: AppStatusBarScaffold.light(
//         body: BlocConsumer<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state is AuthSuccess) {
//               context.go('/conversations');
//             }
//           },
//           builder: (context, state) {
//             return SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             const SizedBox(height: 32),
//                             const AppText(
//                               'Welcome to shule direct',
//                               textAlign: TextAlign.center,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             const SizedBox(height: 24),
//                             const Center(
//                               child: ScoreGauge(),
//                             ),
//                             const SizedBox(height: 32),
//                             AppLabeledField(
//                               label: 'Email/Username',
//                               field: AppTextField(
//                                 controller: _emailController,
//                                 hintText: 'Enter your email',
//                                 keyboardType: TextInputType.emailAddress,
//                                 fillColor: AppColors.emailPasswordColor,
//                               ),
//                             ),
//                             if (state is AuthError) ...[
//                               const SizedBox(height: 8),
//                               AppText(
//                                 state.message,
//                                 fontSize: 13,
//                                 color: AppColors.errorColor,
//                               ),
//                             ],
//                             const SizedBox(height: 16),
//                             AppLabeledField(
//                               label: 'Password',
//                               field: AppTextField(
//                                 controller: _passwordController,
//                                 hintText: 'Enter your password',
//                                 obscureText: _obscurePassword,
//                                 fillColor: AppColors.emailPasswordColor,
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _obscurePassword
//                                         ? Icons.visibility_off
//                                         : Icons.visibility,
//                                     color: AppColors.textSecondary,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       _obscurePassword = !_obscurePassword;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                             AppTextButton(
//                               label: 'Forgot Password?',
//                               alignment: Alignment.centerRight,
//                               onPressed: () {},
//                             ),
//                             const SizedBox(height: 24),
//                             AppPrimaryButton(
//                               label: 'Continue',
//                               isLoading: state is AuthLoading,
//                               onPressed: () {
//                                 context.read<AuthCubit>().login(
//                                       email: _emailController.text.trim(),
//                                       password: _passwordController.text.trim(),
//                                     );
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const AppText(
//                                   "Don't have an account? ",
//                                 ),
//                                 AppLinkText(
//                                   label: 'Register Now',
//                                   onTap: () {},
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 24),
//                           ],
//                         ),
//                       ),
//                     ),
//                     if (MediaQuery.viewInsetsOf(context).bottom == 0)
//                       Padding(
//                         padding: EdgeInsets.only(bottom: 5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const AppText(
//                               'All Rights Reserved (C) shule direct',
//                               fontSize: 11,
//                               color: AppColors.textSecondary,
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColors.primary,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: RichText(
//                                 textAlign: TextAlign.center,
//                                 text: const TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: 'shule\n',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: 'direct',
//                                       style: TextStyle(
//                                         color: Colors.yellow,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
