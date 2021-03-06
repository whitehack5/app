import 'package:fluro/fluro.dart';
import 'package:memorare/router/mobile/route_handlers.dart';
import 'package:memorare/router/web/route_handlers.dart';
import 'package:memorare/router/route_names.dart';

class FluroRouter {
  static Router router = Router();

  static void setupMobileRouter() {
    router.define(
      AccountRoute,
      handler: MobileRouteHandlers.account,
    );

    router.define(
      AddQuoteContentRoute,
      handler: MobileRouteHandlers.addQuote,
    );

    router.define(
      AdminTempQuotesRoute,
      handler: MobileRouteHandlers.adminTempQuotes,
    );

    router.define(
      AuthorRoute,
      handler: MobileRouteHandlers.author,
    );

    router.define(
      DashboardRoute,
      handler: MobileRouteHandlers.dashboard,
    );

    router.define(
      DeleteAccountRoute,
      handler: MobileRouteHandlers.deleteAccount,
    );

    router.define(
      DraftsRoute,
      handler: MobileRouteHandlers.drafts,
    );

    router.define(
      FavouritesRoute,
      handler: MobileRouteHandlers.favourites,
    );

    router.define(
      ForgotPasswordRoute,
      handler: MobileRouteHandlers.forgotPassword,
    );

    router.define(
      EditEmailRoute,
      handler: MobileRouteHandlers.editEmail,
    );

    router.define(
      EditPasswordRoute,
      handler: MobileRouteHandlers.editPassword,
    );

    router.define(
      HomeRoute,
      handler: MobileRouteHandlers.home,
    );

    router.define(
      ListsRoute,
      handler: MobileRouteHandlers.lists,
    );

    router.define(
      ListRoute,
      handler: MobileRouteHandlers.list,
    );

    router.define(
      PublishedQuotesRoute,
      handler: MobileRouteHandlers.pubQuotes,
    );

    router.define(
      QuotePageRoute,
      handler: MobileRouteHandlers.quote,
    );

    router.define(
      QuotesRoute,
      handler: MobileRouteHandlers.quotes,
    );

    router.define(
      QuotidiansRoute,
      handler: MobileRouteHandlers.quotidians,
    );

    router.define(
      RootRoute,
      handler: MobileRouteHandlers.quotidian,
    );

    router.define(
      ReferenceRoute,
      handler: MobileRouteHandlers.reference,
    );

    router.define(
      SigninRoute,
      handler: MobileRouteHandlers.signin,
    );

    router.define(
      SignupRoute,
      handler: MobileRouteHandlers.signup,
    );

    router.define(
      TempQuotesRoute,
      handler: MobileRouteHandlers.tempquotes,
    );

    router.define(
      TopicRoute,
      handler: MobileRouteHandlers.topic,
    );

    router.define(
      TopicsRoute,
      handler: MobileRouteHandlers.topics,
    );
  }

  static void setupWebRouter() {
    router.define(
      AboutRoute,
      handler: WebRouteHandlers.about,
    );

    router.define(
      AccountRoute,
      handler: WebRouteHandlers.account,
    );

    router.define(
      AddQuoteContentRoute,
      handler: WebRouteHandlers.addQuote,
    );

    router.define(
      AddQuoteAuthorRoute,
      handler: WebRouteHandlers.addQuoteAuthor,
    );

    router.define(
      AddQuoteCommentRoute,
      handler: WebRouteHandlers.addQuoteComment,
    );

    router.define(
      AddQuoteReferenceRoute,
      handler: WebRouteHandlers.addQuoteReference,
    );

    router.define(
      AddQuoteTopicsRoute,
      handler: WebRouteHandlers.addQuoteTopics,
    );

    router.define(
      AdminTempQuotesRoute,
      handler: WebRouteHandlers.adminTempQuotes,
    );

    router.define(
      AuthorRoute,
      handler: WebRouteHandlers.author,
    );

    router.define(
      ContactRoute,
      handler: WebRouteHandlers.contact,
    );

    router.define(
      DashboardRoute,
      handler: WebRouteHandlers.dashboard,
    );

    router.define(
      DeleteAccountRoute,
      handler: WebRouteHandlers.deleteAccount,
    );

    router.define(
      DraftsRoute,
      handler: MobileRouteHandlers.drafts,
    );

    router.define(
      EditEmailRoute,
      handler: WebRouteHandlers.editEmail,
    );

    router.define(
      EditPasswordRoute,
      handler: WebRouteHandlers.editPassword,
    );

    router.define(
      FavouritesRoute,
      handler: WebRouteHandlers.favourites,
    );

    router.define(
      ForgotPasswordRoute,
      handler: WebRouteHandlers.forgotPassword,
    );

    router.define(
      RootRoute,
      handler: WebRouteHandlers.home,
    );

    router.define(
      ListRoute,
      handler: WebRouteHandlers.list,
    );

    router.define(
      ListsRoute,
      handler: WebRouteHandlers.lists,
    );

    router.define(
      PrivacyRoute,
      handler: WebRouteHandlers.privacy,
    );

    router.define(
      PublishedQuotesRoute,
      handler: WebRouteHandlers.publishedQuotes,
    );

    router.define(
      QuotePageRoute,
      handler: WebRouteHandlers.quotePage,
    );

    router.define(
      QuotesRoute,
      handler: WebRouteHandlers.quotesPage,
    );

    router.define(
      QuotidiansRoute,
      handler: WebRouteHandlers.quotidians,
    );

    router.define(
      ReferenceRoute,
      handler: WebRouteHandlers.reference,
    );

    router.define(
      SigninRoute,
      handler: WebRouteHandlers.signin,
    );

    router.define(
      SignupRoute,
      handler: WebRouteHandlers.signup,
    );

    router.define(
      TempQuotesRoute,
      handler: WebRouteHandlers.tempQuotes,
    );

    router.define(
      TodayRoute,
      handler: WebRouteHandlers.today,
    );

    router.define(
      TopicRoute,
      handler: WebRouteHandlers.topic,
    );

    router.define(
      TopicsRoute,
      handler: WebRouteHandlers.topics,
    );

    router.define(
      UndefinedRoute,
      handler: WebRouteHandlers.undefined,
    );
  }
}
