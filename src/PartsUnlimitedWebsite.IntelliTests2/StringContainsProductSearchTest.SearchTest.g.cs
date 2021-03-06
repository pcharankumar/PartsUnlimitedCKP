using Microsoft.AspNet.Identity.EntityFramework;
using System.Data.Entity;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Threading.Tasks;
using System.Collections.Generic;
using PartsUnlimited.Models;
using PartsUnlimited.ProductSearch;
using Microsoft.Pex.Framework.Generated;
// <auto-generated>
// This file contains automatically generated tests.
// Do not modify this file manually.
// 
// If the contents of this file becomes outdated, you can delete it.
// For example, if it no longer compiles.
// </auto-generated>
using System;

namespace PartsUnlimited.ProductSearch.Tests
{
    public partial class StringContainsProductSearchTest
    {

[TestMethod]
[PexGeneratedBy(typeof(StringContainsProductSearchTest))]
public void SearchTest498()
{
    using (PexDisposableContext disposables = PexDisposableContext.Create())
    {
      StringContainsProductSearch stringContainsProductSearch;
      Task<IEnumerable<Product>> task;
      stringContainsProductSearch =
        new StringContainsProductSearch((IPartsUnlimitedContext)null);
      task = this.SearchTest(stringContainsProductSearch, (string)null);
      disposables.Add((IDisposable)task);
      disposables.Dispose();
      Assert.IsNotNull((object)task);
      Assert.AreEqual<TaskStatus>(TaskStatus.Faulted, ((Task)task).Status);
      Assert.AreEqual<bool>(false, ((Task)task).IsCanceled);
      Assert.IsNull(((Task)task).AsyncState);
      Assert.AreEqual<bool>(true, ((Task)task).IsFaulted);
      Assert.IsNotNull((object)stringContainsProductSearch);
    }
}

[TestMethod]
[PexGeneratedBy(typeof(StringContainsProductSearchTest))]
public void SearchTest731()
{
    using (PexDisposableContext disposables = PexDisposableContext.Create())
    {
      StringContainsProductSearch stringContainsProductSearch;
      Task<IEnumerable<Product>> task;
      stringContainsProductSearch =
        new StringContainsProductSearch((IPartsUnlimitedContext)null);
      task = this.SearchTest(stringContainsProductSearch, "");
      disposables.Add((IDisposable)task);
      disposables.Dispose();
      Assert.IsNotNull((object)task);
      Assert.AreEqual<TaskStatus>(TaskStatus.Faulted, ((Task)task).Status);
      Assert.AreEqual<bool>(false, ((Task)task).IsCanceled);
      Assert.IsNull(((Task)task).AsyncState);
      Assert.AreEqual<bool>(true, ((Task)task).IsFaulted);
      Assert.IsNotNull((object)stringContainsProductSearch);
    }
}

[TestMethod]
[PexGeneratedBy(typeof(StringContainsProductSearchTest))]
public void SearchTest567()
{
    using (PexDisposableContext disposables = PexDisposableContext.Create())
    {
      StringContainsProductSearch stringContainsProductSearch;
      Task<IEnumerable<Product>> task;
      stringContainsProductSearch =
        new StringContainsProductSearch((IPartsUnlimitedContext)null);
      task = this.SearchTest(stringContainsProductSearch, "\0");
      disposables.Add((IDisposable)task);
      disposables.Dispose();
      Assert.IsNotNull((object)task);
      Assert.AreEqual<TaskStatus>(TaskStatus.Faulted, ((Task)task).Status);
      Assert.AreEqual<bool>(false, ((Task)task).IsCanceled);
      Assert.IsNull(((Task)task).AsyncState);
      Assert.AreEqual<bool>(true, ((Task)task).IsFaulted);
      Assert.IsNotNull((object)stringContainsProductSearch);
    }
}

[TestMethod]
[PexGeneratedBy(typeof(StringContainsProductSearchTest))]
public void SearchTest620()
{
    using (PexDisposableContext disposables = PexDisposableContext.Create())
    {
      StringContainsProductSearch stringContainsProductSearch;
      Task<IEnumerable<Product>> task;
      stringContainsProductSearch =
        new StringContainsProductSearch((IPartsUnlimitedContext)null);
      task = this.SearchTest(stringContainsProductSearch, "H");
      disposables.Add((IDisposable)task);
      disposables.Dispose();
      Assert.IsNotNull((object)task);
      Assert.AreEqual<TaskStatus>(TaskStatus.Faulted, ((Task)task).Status);
      Assert.AreEqual<bool>(false, ((Task)task).IsCanceled);
      Assert.IsNull(((Task)task).AsyncState);
      Assert.AreEqual<bool>(true, ((Task)task).IsFaulted);
      Assert.IsNotNull((object)stringContainsProductSearch);
    }
}

[TestMethod]
[PexGeneratedBy(typeof(StringContainsProductSearchTest))]
[Ignore]
[PexDescription("the test state was: path bounds exceeded")]
public void SearchTest01()
{
    using (PexDisposableContext disposables = PexDisposableContext.Create())
    {
      PartsUnlimitedContext partsUnlimitedContext;
      StringContainsProductSearch stringContainsProductSearch;
      Task<IEnumerable<Product>> task;
      partsUnlimitedContext = new PartsUnlimitedContext();
      partsUnlimitedContext.Products = (IDbSet<Product>)null;
      partsUnlimitedContext.Orders = (IDbSet<Order>)null;
      partsUnlimitedContext.Categories = (IDbSet<Category>)null;
      partsUnlimitedContext.CartItems = (IDbSet<CartItem>)null;
      partsUnlimitedContext.OrderDetails = (IDbSet<OrderDetail>)null;
      partsUnlimitedContext.RainChecks = (IDbSet<Raincheck>)null;
      partsUnlimitedContext.Stores = (IDbSet<Store>)null;
      ((IdentityDbContext<ApplicationUser, IdentityRole, string, 
                          IdentityUserLogin, IdentityUserRole, IdentityUserClaim>)partsUnlimitedContext)
        .Users = (IDbSet<ApplicationUser>)null;
      ((IdentityDbContext<ApplicationUser, IdentityRole, string, 
                          IdentityUserLogin, IdentityUserRole, IdentityUserClaim>)partsUnlimitedContext)
        .Roles = (IDbSet<IdentityRole>)null;
      ((IdentityDbContext<ApplicationUser, IdentityRole, string, 
                          IdentityUserLogin, IdentityUserRole, IdentityUserClaim>)partsUnlimitedContext)
        .RequireUniqueEmail = false;
      disposables.Add((IDisposable)partsUnlimitedContext);
      stringContainsProductSearch = new StringContainsProductSearch
                                        ((IPartsUnlimitedContext)partsUnlimitedContext);
      task = this.SearchTest(stringContainsProductSearch, "");
      disposables.Add((IDisposable)task);
      disposables.Dispose();
    }
}

[TestMethod]
[PexGeneratedBy(typeof(StringContainsProductSearchTest))]
public void SearchTest780()
{
    using (PexDisposableContext disposables = PexDisposableContext.Create())
    {
      StringContainsProductSearch stringContainsProductSearch;
      Task<IEnumerable<Product>> task;
      stringContainsProductSearch =
        new StringContainsProductSearch((IPartsUnlimitedContext)null);
      task = this.SearchTest(stringContainsProductSearch, "\0\0");
      disposables.Add((IDisposable)task);
      disposables.Dispose();
      Assert.IsNotNull((object)task);
      Assert.AreEqual<TaskStatus>(TaskStatus.Faulted, ((Task)task).Status);
      Assert.AreEqual<bool>(false, ((Task)task).IsCanceled);
      Assert.IsNull(((Task)task).AsyncState);
      Assert.AreEqual<bool>(true, ((Task)task).IsFaulted);
      Assert.IsNotNull((object)stringContainsProductSearch);
    }
}
    }
}
