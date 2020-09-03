import NewUserForm from './users/NewUserForm.vue';
import EditUserForm from './users/EditUserForm.vue';
import SignIn from './logins/SignIn.vue';
import ForgotPW from './logins/Forgot.vue';
import ResetPW from './logins/Reset.vue';
import NewReviewForm from './reviews/NewReviewForm.vue';
import ShowReview from './reviews/ShowReview.vue';

export default {
  'new-user-form': NewUserForm,
  'edit-user-form': EditUserForm,
  'new-review-form': NewReviewForm,
  'show-review': ShowReview,
  'sign-in': SignIn,
  'forgot-password': ForgotPW,
  'reset-password': ResetPW,
}