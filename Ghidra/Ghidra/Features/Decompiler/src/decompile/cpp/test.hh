/* ###
 * IP: GHIDRA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/// \file test.hh
/// \brief Simple test framework
///
/// Include this file and any additional headers. Use TEST(testname) as
/// prototype in test function definitions.  E.g.
///     test.cc:
///         \#include "float.hh"
///         \#include "test.hh"
///
///         TEST(zero_is_less_than_one) {
///             ASSERT(0.0 < 1.0);
///         }
///
#ifndef __TEST_HH__
#define __TEST_HH__

#include <vector>
#include <set>
#include <string>
#include <sstream>
#include <iostream>

namespace ghidra {

using std::vector;
using std::set;
using std::string;
using std::ostringstream;
using std::cout;
using std::cerr;
using std::endl;

typedef void (*testfunc_t)();	///< A unit-test function

/// \brief Simple unit test class
///
/// The macro TEST instantiates this object with a name and function pointer.
/// The static run() method calls all the function pointers of all instantiated
/// objects.
struct UnitTest {
  static vector<UnitTest *> tests;		///< The collection of test objects
  string name;					///< Name of the test
  testfunc_t func;				///< Call-back function executing the test

  /// \brief Constructor
  ///
  /// \param name is the identifier for the test
  /// \param func is a call-back function that executes the test
  UnitTest(const string &name,testfunc_t func) :
      name(name), func(func)
  {
    tests.push_back(this);
  }

  static int run(set<string> &testNames);	///< Run all the instantiated tests
};

} // End namespace ghidra

/// \brief Main unit test macro
#define TEST(testname)                                                                                                 \
    void testname();                                                                                                   \
    UnitTest testname##_obj{ #testname, testname };                                                                        \
    void testname()

/// \brief Assert that a boolean is \b true for a unit test
#define ASSERT(test)                                                                                                   \
    if (!(test)) {                                                                                                     \
        cerr << "  failed at " << __FILE__ << ":" << __LINE__ << " asserting \"" << #test << "\"." << endl;  \
        throw 0;                                                                                                       \
    }

/// \brief Assert that two values are equal for a unit test
#define ASSERT_EQUALS(a, b)                                                                                            \
    if ((a) != (b)) {                                                                                                  \
        ostringstream ssa, ssb;                                                                                    \
        ssa << (a);                                                                                                    \
        ssb << (b);                                                                                                    \
        cerr << "  failed at " << __FILE__ << ":" << __LINE__ << " asserting \"" << ssa.str()                     \
                  << " == " << ssb.str() << "\"." << endl;                                                          \
        throw 0;                                                                                                       \
    }

/// \brief Assert that two values are not equal for a unit test
#define ASSERT_NOT_EQUALS(a, b)                                                                                        \
    if ((a) == (b)) {                                                                                                  \
        ostringstream ssa, ssb;                                                                                    \
        ssa << (a);                                                                                                    \
        ssb << (b);                                                                                                    \
        cerr << "  failed at " << __FILE__ << ":" << __LINE__ << " asserting \"" << ssa.str()                     \
                  << " != " << ssb.str() << "\"." << endl;                                                          \
        throw 0;                                                                                                       \
    }

#endif
