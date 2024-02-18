import React from 'react';

import {
  MdHome,
  MdLock,
} from 'react-icons/md';
import MainDashboard from 'views/admin/default';
import SignInCentered from 'views/auth/signIn';

import { Icon } from '@chakra-ui/react';

const routes = [
  {
    name: "Sign IN",
    layout: "/auth",
    icon: <Icon as={MdLock} width='20px' height='20px' color='inherit' />,
    path: "/sign-in",
    component: SignInCentered,
  },
  {
    name: "Main Dashboard",
    layout: "/main",
    path: "/dashboard",
    icon: <Icon as={MdHome} width='20px' height='20px' color='inherit' />,
    component: MainDashboard,
  },
];

export default routes;
